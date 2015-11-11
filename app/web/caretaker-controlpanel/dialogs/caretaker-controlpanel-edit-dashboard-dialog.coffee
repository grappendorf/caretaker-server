Polymer

  is: 'caretaker-controlpanel-edit-dashboard-dialog'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    dashboard: {type: Object}

  start: ->
    @processing = false
    @message = null
    @_validate()
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
    @resolve @dashboard

  _cancel: ->
    @end()

  _validate: ->
    @valid = @dashboard.name.length > 0

  _error: (errors) ->
    @processing = false
    @message = 'message.error_in_input_data'
