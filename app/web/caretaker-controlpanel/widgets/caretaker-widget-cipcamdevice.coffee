Polymer 'caretaker-widget-cipcamdevice',

  ready: ->
    @device = @widget.device
    @reloadImage()

  reloadImage: ->
    @$.image.src = "http://#{@device.address}/snapshot.cgi?t=#{(new Date).getTime()}"
    @async @reloadImage, null, @device.refresh_interval * 1000

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
