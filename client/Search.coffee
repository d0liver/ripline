$                   = require "jquery"
Bloodhound          = require 'bloodhound-js'
{tokenizers}        = Bloodhound
suggestion_template = require "../views/suggestion.jade"
pagination_controls = require '../views/pagination.jade'
clipboard           = require "./clipboard"
conf                = require "./confirm"
debug               = require "./debug"
gqlQuery            = require "./gqlQuery"

# TODO: This whole thing is a bit sloppy and probably needs to be reworked.
# This is a temporary solution. Needs to match what's on the server.
PAGE_SIZE=5

class Search
	$search = null; $search_results = null
	page_count = null; current_page = 0
	text = null
	$clear = null

	addClearTextButton = ($search) ->
		$wrapper = $ '<div></div>'
		$wrapper.css position: 'relative', display: 'inline'
		$search.wrap $wrapper
		$clear = $ '<span class="fa fa-times"></span>'
		.css
			'font-size': 20
			position: 'absolute'
			right: 20, top: 0
			display: 'none'
			cursor: 'pointer'

		$clear.click (e) ->
			$search.val ''
			$search.trigger 'change'
			$search.focus()

		$search.after $clear

	constructor: ->
		# type='search' doesn't do the right thing in FF so we add our own
		# clear text button.
		$search = $ '#search'
		$search_results = $ '#search-results'

		addClearTextButton $search

		$search.on 'change keyup', =>
			@refresh()

		showPage = @showPage


		$('.search').on 'click', '.page-button', (e) ->
			new_page = $(@).data 'page'

			page_num = if new_page is 'previous'
				current_page - 1
			else if new_page is 'next'
				current_page + 1
			else
				parseInt new_page

			showPage page_num

	refresh: ->
		# Bail if nothing has changed.
		return if text is $search.val()
		$search_results.html ''; $('.pagination-container').html ''
		current_page = 0
		text = $search.val()
		$clear.css display: if text is '' then 'none' else 'inline'
		# Bail if we don't have a search value currently
		if text is '' then return

		gqlQuery """
			query snippetsCount($text: String!) {
				snippetsCount(text: $text)
			}
		""", {text}
		.done ({data: snippetsCount: count}) =>
			page_count = Math.ceil count/PAGE_SIZE
			@showPage 0

	showPage: (page_num) ->
		current_page = page_num

		# We have to redisplay the pagination controls each time we load a new
		# page because the 'Next' and 'Previous' buttons disappear when they
		# can't be used.
		if page_count > 1
			$('.pagination-container').html pagination_controls {count: page_count, current_page}

		# Make the current page number bolded
		$(":not([data-page=#{current_page}])").css 'font-weight', 'normal'
		$("[data-page=#{current_page}]").css 'font-weight', 'bold'

		gqlQuery """
			query search($text: String!, $page: Int){
				snippets(text: $text, page: $page) {
					_id
					title
					text
					username
				}
			}
		""", {text, page: page_num}
		.done ({data: snippets: results}) ->
			$search_results.html ''
			for result in results
				$search_results.append suggestion_template result

module.exports = Search
