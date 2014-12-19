Polymer 'coyoho-controlpanel-edit-widget-dialog',

  start: ->
    @processing = false
    @$.devicesNames.go()
    @validate()
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
    @resolve @widget

  cancel: ->
    @end()

  validate: ->
    @valid = @widget.device.id?

  'widget.device.idChanged': ->
    @validate()
