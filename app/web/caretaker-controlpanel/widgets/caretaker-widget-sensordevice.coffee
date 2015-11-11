Polymer

  is: 'caretaker-widget-sensordevice'

  properties:
    widget: {type: Object}
    websocket: {type: Object}

  attached: ->
    @formats =
      '1': (v) -> "#{v.toFixed(1)} °C"
      '2': (v) -> "#{v.toFixed(1)} Lux"

    Epoch.Time.Gauge.prototype.getStyles = (s) ->
      switch s
        when '.epoch .gauge .arc.outer' then {fill: "#7AA4B8", stroke: "#7AA4B8", 'stroke-width': "4px"}
        when '.epoch .gauge .arc.inner' then {fill: "#237B99", stroke: "#237B99", 'stroke-width': "4px"}
        when '.epoch .gauge .tick' then {fill: "#237B99", stroke: "#237B99", 'stroke-width': "2px"}
        when '.epoch .gauge .needle' then {fill: "#ED8E06", stroke: "#ED8E06", 'stroke-width': "2px"}
        when '.epoch .gauge .needle-base' then {fill: "#D65910", stroke: "#D65910", 'stroke-width': "2px"}
        else {fill: "#FFF", stroke: "#FFF", 'stroke-width': "1px"}
    Epoch.Time.Gauge.prototype.textY = -> @height

    @graphs = {}
    @device = @widget.device
    for sensor,index in @device.sensors
      sensor.id = index

    mutationObserver = new MutationObserver (mutations) =>
      graphElements = ((n for n in m.addedNodes when n.nodeName == 'DIV')[0] for m in mutations)
      for element in graphElements
        @_createGraph element

    mutationObserver.observe @$.graphContainer,
      attributes: false
      childList: true

  updateState: (e) ->
    return if e.id != @device.id
    for value,id in e.state
      @graphs[id].update value

  _createGraph: (element) ->
    options =
      el: element
      format: @formats[element.getAttribute('type')]
      domain: [parseInt(element.getAttribute('min')), parseInt(element.getAttribute('max'))]
      value: 100
    graph = new Epoch._typeMap['time.gauge'] options
    graph.draw()
    @graphs[element.getAttribute('id')] = graph
