Polymer 'coyoho-websocket',

  trigger: (event, data) ->
    @websocketDispatcher.trigger event, data

  urlChanged: ->
    if @url
      @websocketDispatcher = new WebSocketRails @url

      for subscribe in @querySelectorAll 'coyoho-websocket-subscribe'
        channel = @websocketDispatcher.subscribe subscribe.channel
        for bind in subscribe.querySelectorAll 'coyoho-websocket-bind'
          channel.bind bind.event, (data) -> bind.fire 'data', data
