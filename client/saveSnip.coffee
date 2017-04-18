$        = require "jquery"
_        = require "underscore"
gqlQuery = require "./gqlQuery"

saveSnip = (update) ->
	_id = snipID()
	gqlQuery """
		mutation updateSnippet($update: SnippetPartial!, $_id: ObjectID!) {
			updateSnippet(update: $update, _id: $_id)
		}
	""", {update, _id}

snipID = -> window.location.href.split("/")[-1..-1][0]

module.exports = saveSnip
