$.rails.allowAction = (link) ->
	return true unless link.attr('data-confirm')
	$.rails.showConfirmDialog(link)
	# look bellow for implementations
	false
# always stops the action since code runs asynchronously

$.rails.confirmed = (link) ->
	link.removeAttr('data-confirm')
	link.trigger('click.rails')

$.rails.showConfirmDialog = (link) ->
	message = link.attr 'data-confirm'
	html = """
		<div class="modal" id="confirmationDialog">
			<div class="modal-dialog">
				<div class="modal-content">
					<div class="modal-header">
						<button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
						<h3>Request confirmation</h3>
					</div>
					<div class="modal-body">
						<p>#{message}</p>
					</div>
					<div class="modal-footer">
						<button type="button" class="btn btn-danger confirm" data-dismiss="modal">Confirm</button>
						<button type="button" class="btn btn-default" data-dismiss="modal">Cancel</button>
					</div>
				</div>
			</div>
		</div>
		"""
	$(html).modal()
	$('#confirmationDialog .confirm').on 'click', -> $.rails.confirmed(link)
