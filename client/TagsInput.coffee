$ = require "jquery"

TagsInput = (save) ->
	# We expect to be initialized after the corresponding input element is
	# available in the document.
	return unless ($tags_input_wrapper = $ '.tags-input-wrapper').length

	inited = false
	$tags_input = $ '.tags-input'
	$tags_container = $ '.tags-container'
	orig_placeholder_text = $tags_input.attr 'placeholder'

	# Whenever we encounter a space in the tags input we encapsulate it in a
	# box with a delete button pretty much exactly like what happens on Stack
	# Overflow.
	boxTags = ->
		new_tags = $tags_input.val().split " "

		for tag in new_tags when tag isnt ''
			$elem = $ "<span class='tag'>#{tag}</span>"
			$delete_button = $ "<span class='fa fa-times delete-tag'></span>"
			$delete_button.click ->
				$(@).parent().remove()
				reinit()
			$elem.append $delete_button
			$tags_container.append $elem

		reinit()
		$tags_input.val ''

		# TODO: This is a pretty bad hack and needs to be fixed but it will get
		# things working for now (some redesign is needed). On the initial page
		# load if the title is not editable then we assume the user is not
		# logged in and remove the input field for the tags so they cannot be
		# edited either.
		if not inited and $('.snip-title').attr('contenteditable') isnt 'true'
			$('.tags-input').remove()

		# Save the new tags if this isn't the initial load
		if inited
			tags = []
			$tags_container.children(".tag").each (i, v) ->
				tags.push $(v).text()

			save {tags}

		else inited = true

		return

	# Check if the list of tags is empty. If it isn't then we use a left margin
	# to push the input off of the previous tag and, we make sure the
	# placeholder text doesn't display (since it normally does when the input
	# is empty but in our case we're faking input values as tags).
	reinit = ->
		if $tags_container.children().length isnt 0
			$tags_input.attr 'placeholder', ''
			$tags_input.css 'margin-left', '5px'
		else
			$tags_input.css 'margin-left', '0px'
			$tags_input.attr 'placeholder', @orig_placeholder_text

	boxTags()

	$tags_input_wrapper.click -> $tags_input.focus()

	$tags_input.on 'input', (e) ->
		boxTags() if ' ' in $(@).val()

	$tags_input.on 'blur', boxTags

	$tags_input.on 'keydown', (e) ->
		# Check for backspace
		if e.which is 8 and $tags_input.val() is ''
			text = $tags_container.children(":last-child").text()
			$tags_container.children(":last-child").remove()
			$tags_input.val text

	$('.snippet-submit').click (e) ->
		$form.submit()

	return

module.exports = TagsInput
