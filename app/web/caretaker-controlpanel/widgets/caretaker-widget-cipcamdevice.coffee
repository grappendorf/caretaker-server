Polymer

  is: 'caretaker-widget-cipcamdevice'

  properties:
    widget: {type: Object}
    websocket: {type: Object}
    token: {type: String}

  attached: ->
    @device = @widget.device
    @_reloadImage()

  _reloadImage: ->
    if document.visibilityState == 'visible'
      @$.imageRequest.go()
    @async @_reloadImage, null, @device.refresh_interval * 1000

  _updateImage: (e) ->
    data = btoa String.fromCharCode.apply null, new Uint8Array(e.detail.response)
    @$.image.src = "data:image/jpg;base64,#{data}"

  _left: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'left'}
    @async @reloadImage, null, 1000

  _right: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'right'}
    @async @reloadImage, null, 1000

  _up: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'up'}
    @async @reloadImage, null, 1000

  _down: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'down'}
    @async @reloadImage, null, 1000

  _cipcamImagePath: (deviceId) ->
    "/cipcam_device/#{deviceId}/image"
