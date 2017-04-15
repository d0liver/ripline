# Node
{Server} = require 'http'
fs       = require 'fs'

# General third party
_             = require 'underscore'
{MongoClient} = require 'mongodb'
co            = require 'co'
{ObjectID}    = require 'mongodb'

# Express
flash      = require 'connect-flash'
bodyParser = require 'body-parser'
express    = require 'express'
session    = require 'express-session'
passport   = require 'passport'
passport = require 'passport'
{OAuth2Strategy} = require 'passport-google-oauth'
# Just to make things a little less verbose further down
auth = passport.authenticate.bind passport, 'google'

graphql_http = require 'express-graphql'

app  = express()
http = Server app
PORT = process.env.PORT ? 3000
DB_URI = if process.env.NODE_ENV is 'development'
	'mongodb://localhost:27017/ripline'
else process.env.MONGODB_URI
SchemaBuilder = require './schema'

app.set 'view engine', 'pug'

# Authentication
app.use session
	secret: 'this is probably useless'
	resave: true
	saveUninitialized: true
app.use passport.initialize()
app.use passport.session()

# Utils
app.use flash()

# Parsers
app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()
app.use express.static 'public'


co ->
	db = yield MongoClient.connect DB_URI
	{schema, rootValue} = SchemaBuilder db

	app.use '/graphql', graphql_http
	  schema: schema
	  rootValue: rootValue
	  graphiql: true

	snippets = db.collection 'snippets'

	app.post '/star/:_id', (req, res) ->
		co ->
			star = user: "placeholder"
			result = yield snippets.update {_id: ObjectID(req.params._id)}, $push: star: star

	# Find the snippets belonging to the current user and display them.
	app.get '/my', (req, res) ->
		# Redirect to login if we're not logged in.
		unless req.isAuthenticated()
			# Save the current uri so that we can come back to it after auth.
			req.session.redirect = req.originalUrl
			res.redirect '/auth/google'
			return
		co ->
			results = yield snippets.find(uid: req.user.id).toArray()
			for snip in results
				snip._id = snip._id.toString()
			res.render "my", snippets: results

	# Find the snippets belonging to the current user and display them.
	app.get '/all', (req, res) ->
		# Redirect to login if we're not logged in.
		unless req.isAuthenticated()
			# Save the current uri so that we can come back to it after auth.
			req.session.redirect = req.originalUrl
			res.redirect '/auth/google'
			return

		co ->
			results = yield snippets.find().toArray()
			for snip in results
				snip._id = snip._id.toString()
			res.render "my", snippets: results

	app.get '/success', (req, res) ->
		res.render "index", success: true

	app.get '/', (req, res) ->
		res.redirect "/search"

	app.get '/search', (req, res) ->
		res.render 'index'

	app.get '/view/:_id', (req, res) ->
		co ->
			_id = ObjectID req.params._id
			snip = yield snippets.findOne {_id}
			snip.tags = snip.tags.join ' '
			res.render 'snip', snip

	# Fetch snippet as json
	app.get '/fetch/:_id', (req, res) ->
		co ->
			_id = ObjectID req.params._id
			snip = yield snippets.findOne {_id}
			res.status(200).json snip

	app.post '/submit', (req, res) ->
		# Bail if we're not logged in
		# return unless req.isAuthenticated()
		co ->
			{text, description, tags = [], _id} = req.body

			try
				_id = ObjectID _id
			catch err
				res.status(200).json
					message: 'Invalid snippet id.'
					code: 'INVALID_SNIPPET_ID'
				return

			# text validation
			if text?.length is 0
				res.status(200).json
					message: 'The body of the snippet cannot be empty.'
					code: 'SNIPPET_BODY_EMPTY'
				return

			# title validation
			if title?.length is 0
				res.status(200).json
					message: 'The title of the snippet cannot be empty.'
					code: 'SNIPPET_TITLE_EMPTY'
				return
			else if title?.length > 80
				res.status(200).json
					message: 'The length of the snippet title cannot exceed 80
					characters.'
					code: 'SNIPPET_TITLE_TOO_LONG'
				return

			# tags validation
			# NOTE: We're currently explicitly allowing an empty tags list.
			for tag in tags
				unless /^[A-Za-z0-9-]+$/.test tag
					res.status(200).json
						message: 'Illegal characters detected in a snippet tag.'
						code: 'SNIPPET_TAG_ILLEGAL'
					return

				if tag.length > 25
					res.status(200).json
						message: 'Snippet tag exceeds maximum allowable length.'
						code: 'SNIPPET_TAG_TOO_LONG'
					return

			# If we made it this far we should be all good to insert the
			# snippet.
			update = $set: {}

			for key in ["text", "title", "tags"] when req.body[key]?
				update.$set[key] = req.body[key]

			console.log "Update is: ", update
			console.log "Id is: ", _id

			result = yield snippets.update {_id}, update
			console.log "Update result: ", result
			res.status(200).json
				code: 'OK'
				message: 'The snippet was inserted successfully.'
		.catch (e) ->
			console.log "Error: ", e
			res.status(200).json
				code: 'SNIPPET_UPDATE_FAILED'
				message: 'Failed to update the snippet.'

	app.get '/add/:_id*?', (req, res) ->
		{params: {_id}} = req
		# Redirect to login if we're not logged in.
		unless req.isAuthenticated()
			# Save the current uri so that we can come back to it after auth.
			req.session.redirect = req.originalUrl
			res.redirect '/auth/google'
			return

		co ->
			if _id
				snip = yield snippets.findOne _id: ObjectID _id
				snip.tags = snip.tags.join " "
			res.render "add", snip ? {}

	# TODO: Split all of this crap out into a different file.
	#### Google Authentication ####
	opts = 
		if process.env.NODE_ENV is 'production'
			clientID: process.env.GOOGLE_CLIENT_ID
			clientSecret: process.env.GOOGLE_CLIENT_SECRET
			callbackURL: '/auth/google/callback'
		else
			try
				{clientID, clientSecret} = JSON.parse fs.readFileSync(".google_oauth")
				clientID: clientID
				clientSecret: clientSecret
				callbackURL: 'http://localhost:8080/auth/google/callback'
			catch err
				console.log "Unusable development oauth credentials for Google."


	google_verify = (accessToken, refreshToken, profile, done) ->
		# We just need a unique user id for the moment so we don't bother
		# fetching data from the db for this user (don't know, don't care).
		process.nextTick ->
			done null, profile

	passport.use new OAuth2Strategy opts, google_verify

	# The first step in Google authentication will involve redirecting
	# the user to google.com. After authorization, Google will redirect
	# the user back to this application at /google/auth/callback
	# (placeholder #3)

	scope = ['https://www.googleapis.com/auth/plus.login']
	app.get '/auth/google', auth {scope}

	passport.serializeUser (user, done) ->
		done null, user

	passport.deserializeUser (user, done) ->
		done null, user

	# If authentication fails, the user will be redirected back to the login page.
	# Otherwise, the primary route function function will be called, which, in this
	# example, will redirect the user to the home page.
	failureRedirect = '/'
	app.get '/auth/google/callback', auth({failureRedirect}), (req, res) ->
		# Authentication was successful
		res.redirect req.session.redirect
		delete req.session.redirect

	#### Development fixtures ####
	if process.env.NODE_ENV is 'development'
		# Check if there are snippets in the database. If not, create some
		# sample snippets to make testing easier.
		unless snippets.findOne()?
			createSampleSnippets db

	return
.catch (err) ->
	console.log err.message
	console.log err.stack

fetchRoot = (req, res) ->
	res.sendFile __dirname + '/public/index.html'

createSampleSnippets = (db) ->
	co ->
		console.log "Creating sample snippets"

		yield db.collection("snippets").insertMany [
				text: "A simple test snippet"
				description: "This is just a simple test snippet"
				tags: ["english"]
			,
				text: "console.log($1);"
				description: "Short javascript console.log"
				tags: ["javascript"]
			,
				text: """
					Lorem ipsum dolor sit amet, consectetur adipiscing elit.
					Donec id sapien nisl. Nam sit amet convallis erat, finibus
					vehicula metus. Pellentesque ullamcorper luctus lacus eget
					blandit. Pellentesque habitant morbi tristique senectus et
					netus et malesuada fames ac turpis egestas. Cras ipsum est,
					dictum nec elit a, condimentum viverra nulla. Integer
					venenatis congue arcu vitae lacinia. Vestibulum tempus eu
					libero varius posuere. Mauris feugiat massa nibh, quis
					ullamcorper sapien mattis vitae. Pellentesque non eleifend
					orci. Integer neque ex, vestibulum vel arcu eget,
					vestibulum convallis mauris. Sed pretium odio sit amet
					tortor mollis, eu eleifend lacus rutrum. Curabitur sit amet
					pharetra est. Curabitur feugiat libero lorem, a finibus
					sapien cursus eget.
				"""
				description: "Lorem Ipsum"
				tags: ["lorem", "ipsum"]
		]

http.listen PORT, () -> console.log "listening on http://localhost:#{PORT}"
