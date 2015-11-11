Polymer

  is: 'caretaker-widget-remotecontroldevice'

  properties:
    widget: {type: Object}
    websocket: {type: Object}

  attached: ->
    @device = @widget.device
    total = @device.num_buttons
    perRow = @device.buttons_per_row
    @rows = ((row * perRow + col for col in [0...perRow]) for row in [0...total / perRow])
    @states = @device.state

  updateState: (e) ->
    return if e.id != @device.id
    @states = e.state

  _press: (e) ->
    num = e.model.num
    @states[num] = 1
    @websocket.trigger 'device.state', id: @device.id, state: {num: num, value: 1}

  _release: (e) ->
    num = e.model.num
    @states[num] = 0
    @websocket.trigger 'device.state', id: @device.id, state: {num: num, value: 0}

  _buttonClass: (states, num) ->
    if states[num] then 'on' else 'off'

  _buttonNum: (num) ->
    num + 1
