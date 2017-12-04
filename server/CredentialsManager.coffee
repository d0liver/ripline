Q        = require 'q'
_        = require 'underscore'
fs       = require 'fs'
co       = require 'co'
readFile = Q.nfbind fs.readFile

## CredentialsManager

CredentialsManager = ->
		fetch: co.wrap (key) ->
			u_key = key.toUpperCase()
			if process.env.NODE_ENV is 'production'
				clientID: process.env["#{u_key}_CLIENT_ID"]
				clientSecret: process.env["#{u_key}_CLIENT_SECRET"]
				callbackURL: '/auth/google/callback'
			else
				try
					contents = yield readFile '.dev_credentials', 'utf8'
					creds = JSON.parse(contents)[key]
					_.extendOwn creds, 
						callbackURL: 'http://localhost:3000/auth/google/callback'
				catch err
					console.log "Unusable development oauth credentials for Google."

module.exports = CredentialsManager
