CredentialsManager = require './CredentialsManager'
{OAuth2Strategy} = require 'passport-google-oauth'
co = require 'co'

# 1. The first step in Google authentication will involve redirecting the user
# to google.com. After authorization, Google will redirect the user back to
# this application at /google/auth/callback (route below)

# 2. If authentication fails, the user will be redirected back to the uri given
# by the failureRedirect option. Otherwise, the primary route function will be
# called, which, in this case will redirect them back to the page that trigger
# the authentication request.

module.exports = co.wrap ({app, passport, db}) ->

	auth = passport.authenticate.bind passport, 'google'

	verify = (accessToken, refreshToken, profile, done) ->
		# We just need a unique user id for the moment so we don't bother
		# fetching data from the db for this user (don't know, don't care).
		process.nextTick ->
			done null, profile

	
	credentials = yield CredentialsManager().fetch 'Google'
	passport.use new OAuth2Strategy credentials, verify

	scope = ['https://www.googleapis.com/auth/plus.login']
	app.get '/auth/google', auth {scope}

	failureRedirect = '/'
	app.get '/auth/google/callback', auth({failureRedirect}), (req, res) ->
		# Authentication was successful
		res.redirect req.session.redirect
		delete req.session.redirect
