Polymer 'coyoho-app',

  created: ->
    @app = @

  login: ->
    @$.sessionManager.connect()

  logout: ->
    @$.sessionManager.disconnect()

  changePassword: ->
    @$.sessionManager.changePassword()

  sessionManagerLoaded: ->
    @login() unless @$.sessionManager.connected

  editProfile: ->
    @$.sessionManager.editProfile()

  authenticationError: ->
    @unauthenticatedLocation = window.location.hash[1..]
    @$.sessionManager.reconnect()

  '$.sessionManager.connectedChanged': ->
    if @$.sessionManager.connected && @unauthenticatedLocation
      @$.router.go @unauthenticatedLocation
      @unauthenticatedLocation = null
