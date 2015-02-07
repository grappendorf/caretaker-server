Polymer 'caretaker-websocket',

  trigger: (event, data) ->
    @websocketDispatcher.trigger event, data

  urlChanged: ->
    if @url
      @websocketDispatcher = new WebSocketRails @url

      for subscribe in @querySelectorAll 'caretaker-websocket-subscribe'
        channel = @websocketDispatcher.subscribe subscribe.channel
        for bind in subscribe.querySelectorAll 'caretaker-websocket-bind'
          channel.bind bind.event, (data) -> bind.fire 'data', data
