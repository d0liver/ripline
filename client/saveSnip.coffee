$        = require "jquery"
_        = require "underscore"
gqlQuery = require "./gqlQuery"

SAVE_DELAY=350
debounce = null
saveSnip = (update) ->
	_id = snipID()
	clearTimeout debounce if debounce
	debounce = setTimeout ->
		gqlQuery """
			mutation updateSnippet($update: SnippetPartial!, $_id: ObjectID!) {
				updateSnippet(update: $update, _id: $_id)
			}
		""", {update, _id}
	, SAVE_DELAY

snipID = -> window.location.href.split("/")[-1..-1][0]

module.exports = saveSnip
