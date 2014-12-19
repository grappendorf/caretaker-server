isManualSliderMove = (sliderKnob) ->
  sliderKnob.classList.contains('dragging')


Polymer 'coyoho-widget-dimmerdevice',

  ready: ->
    @device = @widget.device
    @value = @device.state
    @sliderKnob = @$.slider.shadowRoot.querySelector '#sliderKnob'

  updateState: (e) ->
    return if e.id != @device.id
    unless isManualSliderMove @sliderKnob
      @value = e.state

  immediateValueChanged: (e) ->
    if isManualSliderMove @sliderKnob
      @websocket.trigger 'device.state', id: @device.id, state: {value: @immediateValue}
