confirm_template = require "../views/confirm.jade"
$                = require "jquery"

module.exports = (opts, done)->
	opts.yes      ?= "Yes"
	opts.no       ?= "No"
	opts.question ?= "Are you sure?"

	$template = $(confirm_template opts)
	$template.on 'click' , '.confirm-dialog-yes', -> done 1; $.modal.close()
	$template.on 'click' , '.confirm-dialog-no', -> done 0; $.modal.close()
	$template.modal()
