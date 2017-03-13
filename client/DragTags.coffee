$ = require "jquery"

class DragTags

	tag_text = ""

	constructor: (search) ->
		$('.tag-section').on 'dragstart', (e) ->
			$tag = $(@)
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

			# The "all" tag is incompatible with other tags (by definition we
			# are showing all snippets so we cannot filter further) so we set
			# the value instead of appending when "all" is used.
			unless 'all' in [tag_text, val]
				$this.val "#{val} #{tag_text}"
				# Select everything after the colon if this is a tag that
				# needs a value filled in (e.g. user: username).
				colon_match = /: ?/
				if colon_match.test tag_text
					match = colon_match.exec(tag_text)
					# If there was a space after the colon then we start
					# hilighting at the next character - otherwise we start
					# right after the colon.
					startpos = if tag_text[match.index + 1] is ' '
						match.index + 3
					else
						match.index + 2

					endpos = startpos + match.input.length
					select @, startpos, endpos

			else
				$this.val tag_text

			search.refresh()

		$('#search').on 'dragenter', (e) -> e.preventDefault()

		$('#search').on 'dragover', (e) -> e.preventDefault()

	# Select a range on the $input field given
	select = (input, start, end) ->
		input.focus()
		input.selectionStart = start
		input.selectionEnd = end

module.exports = DragTags
