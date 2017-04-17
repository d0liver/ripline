require 'typeahead.js'
require "jquery-modal"

$            = require 'jquery'
Router       = require './Router'
Search       = require './Search'
TagsInput    = require './TagsInput'
clipboard    = require './clipboard'
DragTags     = require './DragTags'
PasteSnippet = require './PasteSnippet'
save         = require './saveSnip'
Router       = require './Router'
gqlQuery     = require './gqlQuery'

$ ->
	hljs.initHighlightingOnLoad()

	# Drives the snippet search
	router = Router()

	# Operate the clipboard on the view snippet page
	$copy = $(".fa-copy.view-icon")
	$copy.click -> clipboard.copy $(@).data 'text'

	router.get '/search': ->
		search = new Search()

		# Allows us to drag and drop tags into the search
		new DragTags search

	router.get '/view/:_id': ({_id}) ->
		# Drives the tags input on the add snippet page
		TagsInput save

		# Handles pasting snippets on the view page. Pasting is used to update
		# (replace) existing snippets or to add a new one.
		new PasteSnippet save

		snipID = -> window.location.href.split("/")[-1..-1][0]
		$('#remove').click -> 
			gqlQuery """
				mutation removeSnippet($_id: ObjectID!) {
					removeSnippet(_id: $_id)
				}
			""", {_id: snipID()}
			.done -> window.location.replace '/'

	router.route()
