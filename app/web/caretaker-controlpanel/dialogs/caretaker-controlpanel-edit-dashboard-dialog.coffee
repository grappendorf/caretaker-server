Polymer 'caretaker-controlpanel-edit-dashboard-dialog',

  start: ->
    @processing = false
    @message = null
    @validate()
    promise = new Promise ((resolve, reject) ->
      @resolve = resolve
    ).bind(@)
    @$.dialog.open()
    promise

  end: ->
    @processing = false
    @async -> @$.dialog.close()

  ok: ->
    @processing = true
    @resolve @dashboard

  cancel: ->
    @end()

  validate: ->
    @valid = @dashboard.name.length > 0

  error: (errors) ->
    @processing = false
    @message = 'message.error_in_input_data'
