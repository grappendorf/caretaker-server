websocketDispatcher = {}


Polymer 'caretaker-websocket',

  created: ->
    @websocketDispatcher = websocketDispatcher

  trigger: (event, data) ->
    websocketDispatcher.trigger event, data

  urlChanged: ->
    websocketDispatcher.instance = new WebSocketRails @url
