Polymer 'caretaker-session-manager',

  created: ->
    @user = ''
    @roles = []
    @userIsAdmin = false
    @token = null

  connect: ->
    @$.loginDialog.show()

  disconnect: ->
    @logout()

  reconnect: ->
    @token = null
    @connect()

  hasRole: (role) ->
    role in @roles

  rolesChanged: ->
    @userIsAdmin = @hasRole 'admin'

  tokenLoaded: ->
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
    @user = e.detail.response.user
    @roles = e.detail.response.roles
    @token = e.detail.response.token

  loginFailed: (e) ->
    @$.loginDialog.processing = false
#    @$.loginDialog.error = e.detail.response.message
    @$.loginDialog.error = 'Not authorized'
    @password = ''

  logout: ->
    @token = null
    @roles = []
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
