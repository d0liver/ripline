{Strategy: GitHubStrategy} = require 'passport-github2'
CredentialsManager         = require './CredentialsManager'
_                          = require 'underscore'
co                         = require 'co'

module.exports = co.wrap ({app, passport, db}) ->
	credentials = yield CredentialsManager().fetch 'GitHub'

	console.log "Credentials: ", credentials
	opts = _.extendOwn credentials,
		callbackURL: "http://localhost:8080/auth/github/callback"

	verify = (accessToken, refreshToken, profile, done) ->
		done null, profile

	passport.use new GitHubStrategy opts, verify

	scope = ['user:email']
	app.get '/auth/github', passport.authenticate 'github', scope

	failureRedirect = '/'
	app.get \
		'/auth/github/callback',
		passport.authenticate('github', {failureRedirect}),
		(req, res) ->
			# Successful authentication, redirect home.
			res.redirect '/'

