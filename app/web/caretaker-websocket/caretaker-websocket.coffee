RECONNECT_DELAY_MILLIS = 10 * 1000

websocketDispatcher = {}
caretaker_websocket_instances = []

Polymer 'caretaker-websocket',

  created: ->
    @websocketDispatcher = websocketDispatcher

  trigger: (event, data) ->
    @websocketDispatcher.instance.trigger event, data

  urlChanged: ->
    @createConnection()

  createConnection: ->
    websocketDispatcher.instance = new WebSocketRails @url
    @installConnectionHandlers()

  reconnect: ->
    websocketDispatcher.instance.reconnect()
    @installConnectionHandlers()

  installConnectionHandlers: ->
    websocketDispatcher.instance._conn.on_close = (e) =>
      @async =>
        @reconnect()
      , null, RECONNECT_DELAY_MILLIS
