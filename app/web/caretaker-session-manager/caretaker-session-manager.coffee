Polymer 'caretaker-session-manager',

  created: ->
    @user = {}
    @roles = []
    @userIsAdmin = false
    @connected = false

  userChanged: ->
    @roles = {}
    @roles[role] = true for role in @user.roles
    @userIsAdmin = @hasRole 'admin'

  connect: ->
    @$.loginDialog.show()

  disconnect: ->
    @logout()

  reconnect: ->
    @connected = false
    @connect()

  hasRole: (role) ->
    role in @user.roles

  connectedLoaded: ->
    @fire 'loaded'

  changePassword: ->
    @$.passwordDialog.show()

  login: ->
    @$.loginDialog.processing = true
    @$.signInRequest.go()

  loginSucceeded: (e) ->
    @$.loginDialog.processing = false
    @$.loginDialog.hide()
    @password = ''
    if e.detail.response.user
      @user = e.detail.response.user
      @connected = true

  loginFailed: (e) ->
    @$.loginDialog.processing = false
    @$.loginDialog.error = e.detail.response.message
    @password = ''

  logout: ->
    @$.signOutRequest.go()

  logoutSucceeded: ->
    @connected = false
    @userIsAdmin = false

  processPasswordChange: ->
    @$.passwordDialog.processing = true
    @$.changePasswordRequest.go()

  passwordChangeSucceeded: ->
    @$.passwordDialog.processing = false
    @$.passwordDialog.hide()

  passwordChangeFailed: (e) ->
    @$.passwordDialog.processing = false
    @$.passwordDialog.error = e.detail.response.message

  editProfile: ->
    @$.profileDialog.show()
