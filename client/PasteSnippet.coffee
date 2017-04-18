$ = require 'jquery'

class PasteSnippet

	constructor: (save) ->
		$save_button = $ '#save'
		$paste_button = $ '.paste-input'
		orig_html = $paste_button.html()
		$input = $ "<textarea spellcheck='false' class='paste-input paste-input-field'>"
		$input.css outline: 'none'
		$input.css border: 'none'
		$input.css color: 'white'
		$input.css resize: 'none'
		$code = $ 'code'

		$checkmark = $ '<span class="paste-success-icon fa fa-check-circle">'

		$paste_button.click (e) ->
			# jQuery's replaceWith will remove this listener so we have to add
			# it each time.
			$input.on 'keyup', (e) ->
				val = $input.val()
				if val isnt ''
					$paste_button.html orig_html
					$input.replaceWith $checkmark
					$checkmark.css opacity: 1
					$checkmark.animate opacity: 0, 2000

					# Set the new code and force hilight js to reinit
					$code.text val
					hljs.initHighlighting.called = false
					hljs.initHighlighting()

					# Save the changes
					save text: val
					.done (r) -> ; # TODO
					.fail (r) -> ; # TODO

			$input.val ''
			$input.insertAfter $paste_button
			$input.focus()

			$paste_button.html "Press ctrl+v"


module.exports = PasteSnippet
