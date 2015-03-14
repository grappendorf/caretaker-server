Polymer 'caretaker-websocket-subscribe',

  domReady: ->
    dispatcher = @parentNode.websocketDispatcher.instance
    channel = dispatcher.subscribe @channel
    bindEvent = (channel, event, elem) ->
      channel.bind event, (data) -> elem.fire 'data', data
    for bind in @querySelectorAll 'caretaker-websocket-bind'
      bindEvent channel, bind.event, bind
