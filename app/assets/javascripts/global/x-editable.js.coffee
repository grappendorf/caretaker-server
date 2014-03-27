ready = ->
	$.fn.editable.defaults.mode = 'inline'
	$.fn.editable.defaults.emptytext = '<i class="fa fa-pencil"></i>'
	$('.editable').editable()

$(document).ready(ready)
$(document).on('page:load', ready)
