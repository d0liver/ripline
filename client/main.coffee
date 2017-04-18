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
tag_template = require '../views/tag.jade'

$ ->
	hljs.initHighlightingOnLoad()

	# Drives the snippet search
	router = Router()

	# Operate the clipboard on the view snippet page
	$copy = $(".fa-copy.view-icon")
	$copy.click -> clipboard.copy $(@).data 'text'

	router.get '/search': ->
		gqlQuery """
			{
				tags
			}
		"""
		.done ({data: {tags}}) ->
			$tags_browser = $ '.tags-browser'
			for tag in tags
				$tags_browser.append tag_template {tag}

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
		$('#title').on 'keyup', ->
			console.log "Saving..."
			save title: $(@).text()

		$('#remove').click -> 
			gqlQuery """
				mutation removeSnippet($_id: ObjectID!) {
					removeSnippet(_id: $_id)
				}
			""", {_id: snipID()}
			.done -> window.location.replace '/'

		$('#copy').click ->
			clipboard.copy $('code').text()

		$('#fork').click ->
			console.log "Kickoff!"
			gqlQuery """
				mutation forkSnippet($_id: ObjectID!) {
					forkSnippet(_id: $_id)
				}
			""", {_id: snipID()}
			.done (result)->
				if result.data.forkSnippet?
					window.location.replace "/view/#{result.data.forkSnippet}"
				else
					window.location.replace '/auth/github'

	router.route()
