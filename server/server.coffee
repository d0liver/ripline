# Node
{Server} = require 'http'
fs       = require 'fs'

# General third party
_             = require 'underscore'
{MongoClient} = require 'mongodb'
co            = require 'co'
{ObjectID}    = require 'mongodb'

# Express
bodyParser = require 'body-parser'
express    = require 'express'
flash      = require 'connect-flash'
session    = require 'express-session'
{graphqlExpress} = require 'graphql-server-express'

# Express: Passport
passport = require 'passport'
{GitHubStrategy} = require 'passport-github2'

# Constants
{NODE_ENV, PORT, MONGODB_URI} = process.env
PORT ?= 3000
MONGODB_URI ?= 'mongodb://localhost:27017/ripline'

# Local Dependencies
SchemaBuilder      = require './schema'
configGoogleAuth   = require './configGoogleAuth'

# Express Middleware and Initialization
app  = express()
http = Server app
app.set 'view engine', 'pug'

# Express Middleware and Initialization: Sessions
app.use session
	secret: 'this is probably useless'
	resave: true
	saveUninitialized: true
app.use passport.initialize()
app.use passport.session()
app.use flash()

# Express Middleware and Initialization: Body Parsers
app.use bodyParser.urlencoded extended: true
app.use bodyParser.json()

app.use express.static 'public'

co ->
	db = yield MongoClient.connect MONGODB_URI
	snippets = db.collection 'snippets'

	configGoogleAuth {app, db, passport}

	app.use '/graphql', graphqlExpress schema: SchemaBuilder db

	app.get '/', (req, res) ->
		res.redirect "/search"

	app.get '/search', (req, res) ->
		res.render 'index'

	# TODO: Do this initialization on the client via GraphQL requests.
	app.get '/view/:_id', (req, res) ->
		co ->
			_id = ObjectID req.params._id
			snip = yield snippets.findOne {_id}
			snip.tags = snip.tags.join ' '
			res.render 'snip', snip

	pass = (user, done) -> done null, user
	passport.serializeUser pass; passport.deserializeUser pass

	#### Development fixtures ####
	if NODE_ENV is 'development' and not yield snippets.findOne()?
		createSampleSnippets db

	return

.catch (err) ->
	console.log err.message
	console.log err.stack

# Server kickoff
http.listen PORT, () -> console.log "listening on http://localhost:#{PORT}"
