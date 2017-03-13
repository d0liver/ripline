_           = require "underscore"
gulp        = require 'gulp'
{log}       = require 'gulp-util'
{exec}      = require 'child_process'
ctags       = require 'gulp-ctags'
browserSync = require 'browser-sync'
nodemon     = require 'gulp-nodemon'

# Browserify stuff
watchify   = require 'watchify'
browserify = require 'browserify'
source     = require 'vinyl-source-stream'
buffer     = require 'vinyl-buffer'
gutil      = require 'gulp-util'
coffee     = require 'gulp-coffee'
sourcemaps = require 'gulp-sourcemaps'
rename     = require "gulp-rename"
sass       = require "gulp-sass"
uglify     = require "gulp-uglify"
_          = require 'underscore'

browserSync = browserSync.create()

bundle = ->
	b.bundle()
	.on 'error', log
	.pipe source 'bundle.js'
	.pipe buffer()
	.pipe sourcemaps.init loadMaps: true, debug: true
	# .pipe uglify debug: true, options: sourceMap: true
	.pipe sourcemaps.write './'
	.pipe gulp.dest 'public/'

opts =
	entries: ['client/main.coffee']
	debug: true
	cache: {},
	packageCache: {},
	plugin: [require "watchify"]
	extensions: ['.coffee']
b = browserify opts
b.transform require "coffeeify", {bare: true, header: false}
b.transform require 'jadeify'
b.on 'log', log
b.on 'update', bundle

gulp.task 'bundle', bundle

gulp.task 'sass', ->
	gulp.src "sass/**/*.sass"
	.pipe sourcemaps.init()
	.pipe sass().on "error", log
	.pipe sourcemaps.write '.'
	.pipe gulp.dest "./public/"
	.pipe browserSync.stream()

gulp.task 'default', ['sass', 'bundle', 'server'], ->
	bundle()
	browserSync.init
		proxy:
			target: "localhost:3000"
		port: 8080

	gulp.watch 'sass/**/*.sass', ['sass']
	gulp.watch '**/*.coffee', ['coffee-tags']
	gulp.watch 'views/*.pug'
		.on 'change', browserSync.reload
	gulp.watch 'public/bundle.js'
		.on 'change', browserSync.reload

gulp.task 'compile-server', ->
	gulp.src './server/*.coffee'
	.pipe coffee bare: true
	.pipe gulp.dest './server'

gulp.task 'coffee-tags', ->
	exec 'coffeetags -R -f tags'

gulp.task 'coffee-lint', ->
	gulp.src ['client/**/*.coffee', 'server/**/*.coffee']
		.pipe coffeelint()
		.pipe coffeelint.reporter()

gulp.task 'server', ->
	stream = nodemon
		script: 'server/server.coffee'
		watch: ['server/*.coffee', 'lib/*.coffee']
		ext: 'coffee'
		env: 'NODE_ENV': 'development'

	stream
		# Force browser reload after server restart.
		.on 'start', -> setTimeout browserSync.reload, 1000
		.on 'crash', ->
			console.log 'Application crashed'
			stream.emit 'restart', 1
		.on 'restart', ->
			console.log 'Application restarted'
