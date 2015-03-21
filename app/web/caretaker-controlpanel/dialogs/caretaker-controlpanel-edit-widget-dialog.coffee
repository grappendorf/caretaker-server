Polymer 'caretaker-controlpanel-edit-widget-dialog',

  start: ->
    @processing = false
    @initial =
      deviceId: @widget.device.id
      title: @widget.title
      width: @widget.width
      height: @widget.height
    console.log @initial
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
    @widget.device.id = @initial.deviceId
    @widget.title = @initial.title
    @widget.width = @initial.width
    @widget.height = @initial.height
    @end()

  validate: ->
    @valid = @widget.device.id?

  'widget.device.idChanged': ->
    @validate()
