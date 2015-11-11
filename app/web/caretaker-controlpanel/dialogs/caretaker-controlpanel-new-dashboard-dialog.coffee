Polymer

  is: 'caretaker-controlpanel-new-dashboard-dialog'

  behaviors: [Grapp.I18NJsBehavior]

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

  _ok: ->
    @processing = true
    @resolve {name: @name}

  _cancel: ->
    @end()

  _validate: ->
    @valid = @name.length > 0

  _error: (errors) ->
    @processing = false
    @message = 'message.error_in_input_data'
