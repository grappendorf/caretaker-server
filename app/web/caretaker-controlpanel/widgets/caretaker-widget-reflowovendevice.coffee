Polymer 'caretaker-widget-reflowovendevice',

  created: ->
    @initialData = [ time: (new Date).getTime(), y: 0 ]

  ready: ->
    @mode = 'Unknwon'
    @state = 'Unknwon'
    @heater = false
    @fan = false
    @device = @widget.device
    @temperature = 0

  domReady: ->
    # Hack: Real time graph styles are currently not computed correctly
    Epoch.Time.Line.prototype.getStyles = (s) ->
      {fill: "#FF6F6F", stroke: "#FF6F6F", 'stroke-width': "2px"}

  start: ->
    @$.graph.clear()
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'start'}

  cool: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'cool'}

  off: ->
    @websocket.trigger 'device.state', id: @device.id, state: {action: 'off'}

  updateState: (e) ->
    @temperature = e.state.temperature.value
    @$.graph.push (new Date()).getTime() / 1000, e.state.temperature.value
    @mode = ['Unknwon', 'Off', 'Reflow', 'Manual',
             'Cool'][if e.state.mode? then e.state.mode + 1 else 0]
    @state = ['Unknwon', 'Idle', 'Error', 'Set', 'Heat', 'Pre-cool', 'Pre-heat', 'Soak',
                    'Reflow', 'Reflow cool', 'Cool',
                    'Complete'][if e.state.state? then e.state.state + 1 else 0]
    @heater = e.state.heater
    @fan = e.state.fan
