Polymer 'caretaker-confirmation-dialog',

  ask: (messageParams)->
    @text = I18n.t @message, messageParams
    promise = new Promise ((resolve, reject) ->
      @resolve = resolve
    ).bind @
    @$.dialog.open()
    promise

  yes: ->
    @async -> @$.dialog.close()
    @resolve()

  no: ->
    @async -> @$.dialog.close()
