Polymer

  is: 'caretaker-widget-dimmerrgbdevice'

  properties:
    widget: {type: Object}
    websocket: {type: Object}

  attached: ->
    @device = @widget.device
    [@red, @green, @blue] = @device.state
    @_updateColor()

  updateState: (e) ->
    return if e.id != @device.id
    unless @$.red.pressed || @$.green.pressed || @$.blue.pressed
      [@red, @green, @blue] = e.state
      @_updateColor()

  _sendRedValue: ->
    @_updateColor @
    @websocket.trigger 'device.state', {id: @device.id, state: {red: @$.red.immediateValue}}

  _sendGreenValue: ->
    @_updateColor @
    @websocket.trigger 'device.state', {id: @device.id, state: {green: @$.green.immediateValue}}

  _sendBlueValue: ->
    @_updateColor @
    @websocket.trigger 'device.state', {id: @device.id, state: {blue: @$.blue.immediateValue}}

  _updateColor: ->
    @$.dimmerColor.style.background =
        "rgb(#{@$.red.immediateValue},#{@$.green.immediateValue},#{@$.blue.immediateValue})"
