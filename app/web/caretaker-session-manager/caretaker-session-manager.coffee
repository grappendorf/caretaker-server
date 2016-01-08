Polymer

  is: 'caretaker-session-manager'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    apiUrl: {type: String }
    user: {type: Object, value: {email: '', roles: [], isAdmin: false}, notify: true, observer: '_userChanged'}
    token: {type: String, value: null, notify: true}

  connect: ->
    @$.loginDialog.show()

  disconnect: ->
    @logout()

  reconnect: ->
    @disconnect()
    @connect()

  login: ->
    @$.loginDialog.processing = true
    @$.signInRequest.generateRequest()

  logout: ->
    @token = null
    @user =
      email: @user.email
      roles: []
      isAdmin: false

  editProfile: ->
    @$.profileDialog.show().then =>
      @$.profileDialog.processing = true

  editPassword: ->
    @$.passwordDialog.show().then =>
      @$.passwordDialog.processing = true
      @$.changePasswordRequest.generateRequest()

  _tokenLoaded: ->
    @fire 'loaded'

  _signInParams: (email, password) ->
    {email: email, password: password}

  _userChanged: ->
    if @user
      @email = @user.email
      @set 'user.isAdmin', @_userHasRole 'admin'

  _userHasRole: (role) ->
    role in @user.roles

  _loginSucceeded: (e) ->
    @$.loginDialog.processing = false
    @$.loginDialog.hide()
    @password = ''
    e.detail.response.user.isAdmin = 'admin' in e.detail.response.user.roles
    @user = e.detail.response.user
    @token = e.detail.response.token

  _loginFailed: (e) ->
    @$.loginDialog.processing = false
    @$.loginDialog.error = @i18n('message.error_wrong_password_or_user_name')
    @password = ''

  _changePasswordPath: (userId) ->
    "/users/#{userId}"

  _changePasswordParams: (userId, password) ->
    {"id": userId, "user[password]": password, "user[password_confirmation]": password}

  _passwordChangeSucceeded: ->
    @$.passwordDialog.processing = false
    @$.passwordDialog.hide()

  _passwordChangeFailed: (e) ->
    @$.passwordDialog.processing = false
    @$.passwordDialog.error = e.detail.response.message
