Polymer 'coyoho-confirmation-dialog',

  ask: ->
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


