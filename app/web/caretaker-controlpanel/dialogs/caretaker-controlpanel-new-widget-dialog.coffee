Polymer 'caretaker-controlpanel-new-widget-dialog',

  start: ->
    @processing = false
    @$.devicesNames.go()
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

  ok: ->
    @processing = true
    @resolve {device_id: @deviceId, title: @title}

  cancel: ->
    @end()

  validate: ->
    @valid = @deviceId?

  deviceIdChanged: ->
    @validate()