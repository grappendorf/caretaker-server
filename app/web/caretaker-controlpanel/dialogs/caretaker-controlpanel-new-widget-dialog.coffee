Polymer

  is: 'caretaker-controlpanel-new-widget-dialog'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}

  observers: [
    '_validate(device.id)'
  ]

  start: ->
    @processing = false
    @$.devicesNames.generateRequest()
    @name = ''
    promise = new Promise ((resolve, reject) ->
      @resolve = resolve
      @reject = reject
    ).bind(@)
    @$.dialog.open()
    promise

  end: ->
    @processing = false
    @async -> @$.dialog.close()

  _ok: ->
    @processing = true
    @resolve {device_id: @deviceId, title: @title}

  _cancel: ->
    @end()

  _validate: ->
    @valid = @deviceId?
