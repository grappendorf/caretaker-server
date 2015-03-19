Polymer 'caretaker-widget-cipcamdevice',

  ready: ->
    @device = @widget.device
    @reloadImage()

  reloadImage: ->
    if document.visibilityState == 'visible'
      @$.imageRequest.go()
    @async @reloadImage, null, @device.refresh_interval * 1000

  updateImage: (e) ->
    data = btoa String.fromCharCode.apply null, new Uint8Array(e.detail.response)
    @$.image.src = "data:image/jpg;base64,#{data}"

  left: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'left'}
    @async @reloadImage, null, 1000

  right: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'right'}
    @async @reloadImage, null, 1000

  up: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'up'}
    @async @reloadImage, null, 1000

  down: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'down'}
    @async @reloadImage, null, 1000
