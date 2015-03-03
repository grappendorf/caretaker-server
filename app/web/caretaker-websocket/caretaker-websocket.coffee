websocketDispatcher = null
subscribes = []

Polymer 'caretaker-websocket',

  trigger: (event, data) ->
    websocketDispatcher.trigger event, data

  ready: ->
    if websocketDispatcher
      @subscribe (s for s in @querySelectorAll 'caretaker-websocket-subscribe')
    else
      Array::push.apply subscribes, (s for s in @querySelectorAll 'caretaker-websocket-subscribe')

  urlChanged: ->
    if @url
      websocketDispatcher = new WebSocketRails @url
    @subscribe subscribes
    subscribes = []

  subscribe: (subscribes) ->
    for subscribe in subscribes
      channel = websocketDispatcher.subscribe subscribe.channel
      for bind in subscribe.querySelectorAll 'caretaker-websocket-bind'
        channel.bind bind.event, (data) -> bind.fire 'data', data
