Polymer

  is: 'caretaker-app-router'

  properties:
    user: {type: Object, observer: '_userChanged'}
    token: {type: String}
    router: {type: Object, notify: true}

  ready: ->
    @router = @$.router

  bindRouteAttributes: (e) ->
    e.detail.model.router = @$.router
    e.detail.model.user = @user
    e.detail.model.token = @token

  _userChanged: ->
    return unless @router
    for route in @router.querySelectorAll 'app-route'
      if route.children.length
        route.children[0].user = @user
