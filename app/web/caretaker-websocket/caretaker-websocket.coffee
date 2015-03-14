websocketDispatcher = {}


Polymer 'caretaker-websocket',

  created: ->
    @websocketDispatcher = websocketDispatcher

  trigger: (event, data) ->
    @websocketDispatcher.instance.trigger event, data

  urlChanged: ->
    websocketDispatcher.instance = new WebSocketRails @url
