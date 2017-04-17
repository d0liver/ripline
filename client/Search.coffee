$                   = require "jquery"
Bloodhound          = require 'bloodhound-js'
{tokenizers}        = Bloodhound
suggestion_template = require "../views/suggestion.jade"
clipboard           = require "./clipboard"
conf                = require "./confirm"
debug               = require "./debug"
gqlQuery           = require "./gqlQuery"

class Search
	$search = null; $search_results = null

	constructor: ->
		$search = $ '#search'
		$search_results = $ '#search-results'
		$search.on 'search', @refresh

	refresh: ->
		$search_results.html ''
		text = $search.val()
		if text is '' then return

		# Bail if we don't have a search value currently
		gqlQuery """
			query search($text: String!){
				snippets(text: $text) {
					_id
					title
					text
					username
				}
			}
		""", {text}
		.done ({data: snippets: results}) ->
			for result in results
				$search_results.append suggestion_template result

module.exports = Search
