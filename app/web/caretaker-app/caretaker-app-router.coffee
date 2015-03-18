Polymer 'caretaker-app-router',

  ready: ->
    @router = @$.router

  bindRouteAttributes: (e) ->
    e.detail.model.router = @$.router
    e.detail.model.sessionManager = @sessionManager
    e.detail.model.token = @sessionManager.token