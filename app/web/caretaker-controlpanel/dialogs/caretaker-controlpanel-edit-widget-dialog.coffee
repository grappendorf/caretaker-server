Polymer

  is: 'caretaker-controlpanel-edit-widget-dialog'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    widget: {type: Object}
    token: {type: String}

  observers: [
    '_validate(widget.device.id)'
  ]

  start: ->
    @processing = false
    @initial =
      deviceId: @widget.device.id
      title: @widget.title
      width: @widget.width
      height: @widget.height
    @$.devicesNames.generateRequest()
    @_validate()
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
    @resolve @widget

  _cancel: ->
    @widget.device.id = @initial.deviceId
    @widget.title = @initial.title
    @widget.width = @initial.width
    @widget.height = @initial.height
    @end()

  _validate: ->
    @valid = @widget.device.id?
