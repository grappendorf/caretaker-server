Polymer

  is: 'caretaker-app-router'

  properties:
    user: {type: Object}
    token: {type: String}
    router: {type: Object, notify: true}

  ready: ->
    @router = @$.router

  bindRouteAttributes: (e) ->
    e.detail.model.router = @$.router
    e.detail.model.user = @user
    e.detail.model.token = @token
