Polymer 'coyoho-controlpanel-new-dashboard-dialog',

  start: ->
    @processing = false
    @message = null
    @name = ''
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
    @resolve {name: @name}

  cancel: ->
    @end()

  validate: ->
    @valid = @name.length > 0

  error: (errors) ->
    @processing = false
    @message = 'message.error_in_input_data'