Polymer 'caretaker-app-router',

  ready: ->
    @router = @$.router

  bindRouteAttributes: (e) ->
    e.detail.model.sessionManager = @sessionManager