Polymer

  is: 'caretaker-widget-switchdevice'

  properties:
    widget: {type: Object}
    websocket: {type: Object}

  attached: ->
    @device = @widget.device
    total = @device.num_switches
    perRow = @device.switches_per_row
    @rows = ((row * perRow + col for col in [0...perRow]) for row in [0...total / perRow])
    @states = @device.state

  updateState: (e) ->
    return if e.id != @device.id
    @states = e.state

  _toggle: (e) ->
    num = e.model.num
    @states[num] = 1 - @states[num]
    @websocket.trigger 'device.state', id: @device.id, state: {num: num, value: @states[num]}

  _switchClass: (states, num) ->
    if states[num] then 'on' else 'off'

  _switchNum: (num) ->
    num + 1
