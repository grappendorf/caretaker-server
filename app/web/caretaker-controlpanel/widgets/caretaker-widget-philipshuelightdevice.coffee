Polymer

  is: 'caretaker-widget-philipshuelightdevice'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    widget: {type: Object}
    websocket: {type: Object}

  attached: ->
    @device = @widget.device
    @state = @device.state
    @mode = 1

  updateState: (e) ->
    return if e.id != @device.id
    unless @$.brightness.pressed || @$.hue.pressed || @$.saturation.pressed
      @state = e.state

  _sendBrightnessValue: ->
    @mode = 1
    @websocket.trigger 'device.state', {id: @device.id, state: {brightness: @$.brightness.immediateValue}}

  _sendHueValue: ->
    @mode = 1
    @websocket.trigger 'device.state', {
      id: @device.id,
      state: {color: {hue: @$.hue.immediateValue, saturation: @$.saturation.immediateValue}}
    }

  _sendSaturationValue: ->
    @mode = 1
    @websocket.trigger 'device.state', {
      id: @device.id,
      state: {color: {hue: @$.hue.immediateValue, saturation: @$.saturation.immediateValue}}
    }

  _sendState: ->
    @websocket.trigger 'device.state', {
      id: @device.id,
      state: @state
    }

  _modeChanged: ->
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
