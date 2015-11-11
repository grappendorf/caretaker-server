Polymer

  is: 'caretaker-widget-dimmerdevice'

  properties:
    widget: {type: Object}
    token: {type: String}

  attached: ->
    @device = @widget.device
    @value = @device.state
    @sliderKnob = @$.slider.querySelector '#sliderKnob'

  updateState: (e) ->
    return if e.id != @device.id
    unless @$.slider.pressed
      @value = e.state

  _sendValue: ->
    @websocket.trigger 'device.state', id: @device.id, state: {value: @$.slider.immediateValue}
