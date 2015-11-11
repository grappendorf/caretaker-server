Polymer

  is: 'caretaker-widget-rotaryknobdevice'

  properties:
    widget: {type: Object}
    websocket: {type: Object}

  attached: ->
    @device = @widget.device
    @value = @device.state

  updateState: (e) ->
    return if e.id != @device.id
    unless @$.knob.press == 1
      @value = e.state

  _valueChanged: ->
    if @$.knob.press == 1
      @websocket.trigger 'device.state', {id: @device.id, state: @value}
