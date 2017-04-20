$        = require "jquery"
gqlQuery = require './gqlQuery'

class DragTags

	tag_text = ""

	selectPlaceholder = (input, tag_text) ->
		# Select everything after the colon if this is a tag that
		# needs a value filled in (e.g. user: username).
		colon_match = /: ?/
		if colon_match.test tag_text
			match = colon_match.exec(tag_text)
			# If there was a space after the colon then we start
			# hilighting at the next character - otherwise we start
			# right after the colon.
			startpos = if tag_text[match.index + 1] is ' '
				match.index + 2
			else
				match.index + 1

			endpos = startpos + match.input.length
			select input, startpos, endpos

	constructor: (search) ->
		$('.tags-browser').on 'dragstart', '.tag-section', (e) ->
			$tag = $(@)
			e.originalEvent.dataTransfer.setData 'text/plain', 'anything'
			tag_text = if $tag.data('val')?
				$tag.data 'val'
			else
				$tag.find('.tag-preview').text()

			# Determines what kind of visual feedback the user is presented
			# with when they drag the item over the drop zone (in this case the
			# search bar)
			e.dropEffect = 'copy'

		$('#search').on 'drop', (e) ->
			e.preventDefault()
			$this = $(@)
			val = $this.val()
			# Prevent extra space at the beginning of input for the first tag.
			if val isnt '' then val = "#{val} "

			# The "all" tag is incompatible with other tags (by definition we
			# are showing all snippets so we cannot filter further) so we set
			# the value instead of appending when "all" is used.
			if tag_text is 'my'
				gqlQuery """
					{
						username
					}
				"""
				.done (result) ->
					unless result.data?.username?
						window.location.replace '/auth/github'
						return

					tag_text = "username: #{result.data.username}"
					$this.val "#{val}#{tag_text}"
					$this.trigger 'change'
			else if 'all' in [tag_text, val]
				$this.val tag_text
				$this.trigger 'change'
			else
				$this.val "#{val}#{tag_text}"
				selectPlaceholder $this[0], tag_text
				$this.trigger 'change'

		$('#search').on 'dragenter', (e) ->
			e.preventDefault()

		$('#search').on 'dragover', (e) ->
			e.preventDefault()

	window.foo = ->
		console.log "TEST"
	# Select a range on the $input field given
	select = (input, start, end) ->
		input.focus()
		input.selectionStart = start
		input.selectionEnd = end

module.exports = DragTags
