Polymer

  is: 'caretaker-app'

  properties:
    app: {type: Object}

  ready: ->
    @app = @

  login: ->
    @$.sessionManager.connect()

  logout: ->
    @$.sessionManager.disconnect()
    @router.go '/'
    @$.sessionManager.connect()

  changePassword: ->
    @$.sessionManager.editPassword()

  sessionManagerLoaded: ->
    @login() unless @$.sessionManager.token

  editProfile: ->
    @$.sessionManager.editProfile()

  authenticationError: ->
    @unauthenticatedLocation = window.location.hash[1..]
    @$.sessionManager.reconnect()

  bindRouteAttributes: (e) ->
    e.detail.model.sessionManager = @sessionManager
