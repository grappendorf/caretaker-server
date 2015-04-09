Polymer 'caretaker-widget-rotaryknobdevice',

  ready: ->
    @device = @widget.device
    @value = @device.state

  updateState: (e) ->
    return if e.id != @device.id
    unless @$.knob.press == 1
      @value = e.state

  valueChanged: ->
    if @$.knob.press == 1
      @websocket.trigger 'device.state', {id: @device.id, state: @value}
