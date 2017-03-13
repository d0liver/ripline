crypto = require "crypto"

exports.passwordHash = (password) ->
	hash = crypto.createHash "sha256"
	hash.update password
	hash.digest "hex"

exports.capitalize = (words) ->
	(for word in words.split ' '
		word[0].toUpperCase() + word[1..]
	).join ' '

exports.trunc = (words, len=80) ->
	if words.length > len
		return words[..len - 4] + "..."
	return words
