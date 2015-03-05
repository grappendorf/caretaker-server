Polymer 'caretaker-widget-switchdevice',

  ready: ->
    @device = @widget.device
    total = @device.num_switches
    perRow = @device.switches_per_row
    @rows = ((row * perRow + col for col in [0...perRow]) for row in [0...total / perRow])
    @states = @device.state
    @classes = (['off', 'on'][state] for state in @states)

  updateState: (e) ->
    return if e.id != @device.id
    for state, num in e.state
      @states[num] = state
      @classes[num] = ['off', 'on'][state]

  toggle: (e) ->
    num = e.target.templateInstance.model.num
    @states[num] = 1 - @states[num]
    @classes[num] = ['off', 'on'][@states[num]]
    @websocket.trigger 'device.state', id: @device.id, state: {num: num, value: @states[num]}
