$ = require "jquery"
_ = require "underscore"

saveSnip = (updates) ->
	console.log "Save snip: ", updates
	data = _.extendOwn _id: snipID(), updates
	console.log "Data: ", data
	$.post '/submit', data

snipID = -> window.location.href.split("/")[-1..-1][0]

module.exports = saveSnip
