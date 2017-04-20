{Strategy: GitHubStrategy} = require 'passport-github2'
CredentialsManager         = require './CredentialsManager'
_                          = require 'underscore'
co                         = require 'co'

module.exports = co.wrap ({app, passport, db}) ->
	credentials = yield CredentialsManager().fetch 'GitHub'

	if process.env.NODE_ENV is 'development'
		opts = _.extendOwn credentials,
			callbackURL: "http://localhost:8080/auth/github/callback"
	else
		opts = _.extendOwn credentials,
			callbackURL: "/auth/github/callback"

	verify = (accessToken, refreshToken, profile, done) ->
		done null, profile

	passport.use new GitHubStrategy opts, verify

	scope = ['user:email']

	app.get '/auth/github',
		(req, res, next) ->
			req.session.return = req.query.return if req.query.return
			next()
		, passport.authenticate 'github', scope

	failureRedirect = '/'
	app.get \
		'/auth/github/callback',
		passport.authenticate('github', {failureRedirect}),
		(req, res) ->
			# Successful authentication, return to page (or home).
			redir = if req.session.return
				req.session.return
			else
				'/'
			delete req.session.return

			res.redirect redir

