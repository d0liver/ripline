# Yanked straight from Stack Overflow, converted to coffee script and a couple of things changed.
# (http://stackoverflow.com/questions/400212/how-do-i-copy-to-the-clipboard-in-javascript)

# Supposedly the document has to be in 'designMode' execCommand 'copy' to work
# but there seems to be some exception for most browsers where input and
# textarea elements are normally automatically in 'designMode'

exports.copy = (text) ->
	text_area = document.createElement "textarea"

	# *** This styling is an extra step which is likely not required. ***
	# 
	# Why is it here? To ensure:
	# 1. the element is able to have focus and selection.
	# 2. if element was to flash render it has minimal visual impact.
	# 3. less flakyness with selection and copying which **might** occur if
	#		 the textarea element is not visible.
	# 
	# The likelihood is the element won't even render, not even a flash,
	# so some of these are just precautions. However in IE the element
	# is visible whilst the popup box asking the user for permission for
	# the web page to copy to the clipboard.
	# 

	# Place in top-left corner of screen regardless of scroll position.
	text_area.style.position = 'fixed'
	text_area.style.top = 0
	text_area.style.left = 0

	# Ensure it has a small width and height. Setting to 1px / 1em
	# doesn't work as this gives a negative w/h on some browsers.
	text_area.style.width = '2em'
	text_area.style.height = '2em'

	# We don't need padding, reducing the size if it does flash render.
	text_area.style.padding = 0

	# Clean up any borders.
	text_area.style.border = 'none'
	text_area.style.outline = 'none'
	text_area.style.boxShadow = 'none'

	# Avoid flash of white box if rendered for any reason.
	text_area.style.background = 'transparent'


	text_area.value = text

	document.body.appendChild text_area

	text_area.select()

	try
		successful = document.execCommand 'copy'
		msg = if successful then 'successful' else 'unsuccessful'
		console.log 'Copying text command was ' + msg
	catch err
		console.log 'Oops, unable to copy'

	document.body.removeChild text_area
