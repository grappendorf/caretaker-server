isManualSliderMove = (sliderKnob) ->
  sliderKnob.classList.contains('dragging')

updateColor = (self) ->
  self.$.dimmerColor.style.background = "rgb(#{self.immediateRed},#{self.immediateGreen},#{self.immediateBlue})"


Polymer 'coyoho-widget-dimmerrgbdevice',

  ready: ->
    @device = @widget.device
    [@red, @green, @blue] = @device.state
    @sliderRed = @$.red.shadowRoot.querySelector '#sliderKnob'
    @sliderGreen = @$.green.shadowRoot.querySelector '#sliderKnob'
    @sliderBlue = @$.blue.shadowRoot.querySelector '#sliderKnob'

  updateState: (e) ->
    return if e.id != @device.id
    unless isManualSliderMove(@sliderRed) || isManualSliderMove(@sliderGreen) || isManualSliderMove(@sliderBlue)
      [@red, @green, @blue] = e.state
      @$.dimmerColor.style.background = "rgb(#{@red},#{@green},#{@blue})"

  immediateRedChanged: ->
    updateColor @
    if isManualSliderMove(@sliderRed)
      @websocket.trigger 'device.state', {id: @device.id, state: {red: @immediateRed}}

  immediateGreenChanged: ->
    updateColor @
    if isManualSliderMove(@sliderGreen)
      @websocket.trigger 'device.state', {id: @device.id, state: {green: @immediateGreen}}

  immediateBlueChanged: ->
    updateColor @
    if isManualSliderMove(@sliderBlue)
      @websocket.trigger 'device.state', {id: @device.id, state: {blue: @immediateBlue}}
