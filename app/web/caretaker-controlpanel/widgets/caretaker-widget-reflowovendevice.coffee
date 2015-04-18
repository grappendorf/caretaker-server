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
    @data = []

  domReady: ->
    # Hack: Real time graph styles are currently not computed correctly
    Epoch.Time.Line.prototype.getStyles = (s) ->
      {fill: "#FF6F6F", stroke: "#FF6F6F", 'stroke-width': "2px"}
    @createGraph()

  createGraph: ->
    console.log @widget.height
    @$.graph.style.height = ['130', '260px', '390px', '520px'][@widget.height - 1]

    @graph = Morris.Line
      element: @$.graph,
      data: @data,
      xkey: 'y',
      ykeys: ['a'],
      labels: ['Series A'],
      resize: true,
      postUnits: ' °c',
      xLabels: "30sec",
      lineColors: ['#9AB7C1'],
      hideHover: 'always',
      goals: [200.0],
      goalLineColors: ['#FF0000'],
    @async @updateData, null, 2000

  updateData: ->
    @data.push {y: (new Date()).getTime(), a: Math.round((Math.random() * 200) * 100)/100}
    @graph.setData @data
    @async @updateData, null, 2000

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
