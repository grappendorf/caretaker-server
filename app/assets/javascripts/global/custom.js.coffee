String.prototype.to_underscore = ->
	this.replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase()

ready = ->

	NProgress.configure
		showSpinner: false

	# Some defaults
	$("#notifications").notify
		stack: 'above'

	# Add tooltips to icon-only links
	$('a.icon-only').each(->
		$(this).attr('data-toggle': 'tooltip')
		$(this).attr(title: $(this).text()) unless $(this).attr('title')
		$(this).tooltip(delay: {show: 1000})
		$(this).html '')

	# Enhance switch buttons and add ajax handlers
	$('div.switch:not(.has-switch)')['bootstrapSwitch']()
	$('div.switch').on 'switch-change', (e, data) ->
		data_link_type = if data.value then 'data-on-link' else 'data-off-link'
		$.ajax(type: 'PUT', url: $(this).attr data_link_type).done (result) ->
			notify_image = '/assets/notify/success.png'
			if result.status && result.status == 'error'
				notify_image = '/assets/notify/error.png'
				$(e.delegateTarget).bootstrapSwitch('toggleState', true);
			if result.message
				$("#notifications").notify 'create',
					title: 'CoYoHo',
					text: result.message,
					icon: notify_image

	# Codemirror
	$('textarea.codemirror').each ->
		CodeMirror.fromTextArea($(this)[0],
			mode: 'ruby',
			theme: 'base16-dark',
			lineNumbers: true,
			matchBrackets: true)

	# Focus on the first form input
	input_fields = $('input[tabindex=0], input[type!=hidden]')
	input_fields.first().focus() if input_fields.size() > 0

	# Serch form (currently only on search form per page is supported)
	$('.form-search-btn-search').click ->
		$('.form-search').submit()
	$('.form-search-btn-reset').click ->
		$('.form-search-input').val ''
		$('.form-search').submit()

$ -> ready()

#$(document).on 'page:load', ->
#	$('[ng-app]').each ->
#		module = $(this).attr('ng-app')
#		angular.bootstrap(this, [module])
