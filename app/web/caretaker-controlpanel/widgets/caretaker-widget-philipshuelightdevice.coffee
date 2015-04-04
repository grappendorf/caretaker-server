isManualSliderMove = (sliderKnob) ->
  sliderKnob.classList.contains('dragging')


Polymer 'caretaker-widget-philipshuelightdevice',

  ready: ->
    @device = @widget.device
    @state = @device.state
    @sliderBrightness = @$.brightness.shadowRoot.querySelector '#sliderKnob'
    @sliderHue = @$.hue.shadowRoot.querySelector '#sliderKnob'
    @sliderSaturation = @$.saturation.shadowRoot.querySelector '#sliderKnob'
    @mode = 1

  updateState: (e) ->
    return if e.id != @device.id
    unless isManualSliderMove(@sliderBrightness) || isManualSliderMove(@sliderHue) || isManualSliderMove(@sliderSaturation)
      @state = e.state

  immediateBrightnessChanged: ->
    if isManualSliderMove(@sliderBrightness)
      @mode = 1
      @websocket.trigger 'device.state', {id: @device.id, state: {brightness: @immediateBrightness}}

  immediateHueChanged: ->
    if isManualSliderMove(@sliderHue)
      @mode = 1
      @websocket.trigger 'device.state', {
        id: @device.id,
        state: {color: {hue: @immediateHue, saturation: @immediateSaturation}}
      }

  immediateSaturationChanged: ->
    if isManualSliderMove(@sliderSaturation)
      @mode = 1
      @websocket.trigger 'device.state', {
        id: @device.id,
        state: {color: {hue: @immediateHue, saturation: @immediateSaturation}}
      }

  sendState: ->
    @websocket.trigger 'device.state', {
      id: @device.id,
      state: @state
    }

  modeChanged: ->
    switch @mode
      when 0
        @state.brightness = 0
        @sendState()
      when 2
        @state.brightness = 255
        @state.color.hue = 47070
        @state.color.saturation = 255
        @sendState()
      when 3
        @state.brightness = 255
        @state.color.hue = 6400
        @state.color.saturation = 255
        @sendState()
