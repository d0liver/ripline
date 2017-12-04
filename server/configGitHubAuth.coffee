{Strategy: GitHubStrategy} = require 'passport-github2'
CredentialsManager         = require './CredentialsManager'
co                         = require 'co'

module.exports = co.wrap ({app, passport, db}) ->
	credentials = yield CredentialsManager().fetch 'GitHub'

	if process.env.NODE_ENV is 'development'
		opts = Object.assign credentials,
			callbackURL: "http://localhost:3000/auth/github/callback"
	else
		opts = Object.assign credentials,
			callbackURL: "/auth/github/callback"

	verify = (accessToken, refreshToken, profile, done) ->
		if profile.username is 'd0liver'
			done null, profile
		else
			done null, false, message: 'Unauthorized user.'

	passport.use new GitHubStrategy opts, verify

	scope = ['user:email']

	app.get '/auth/github',
		(req, res, next) ->
			req.session.return = req.query.return if req.query.return
			next()
		, passport.authenticate 'github', scope

	failureRedirect = '/'
	failureFlash = true
	app.get \
		'/auth/github/callback',
		passport.authenticate('github', {failureRedirect, failureFlash}),
		(req, res) ->
			# Successful authentication, return to page (or home).
			redir = if req.session.return
				req.session.return
			else
				'/'
			delete req.session.return

			res.redirect redir
