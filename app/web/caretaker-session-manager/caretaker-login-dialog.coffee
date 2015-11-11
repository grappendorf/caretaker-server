Polymer

  is: 'caretaker-login-dialog'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    email: {type: String, value: '', notify: true}
    password: {type: String, value: '', notify: true}
    processing: {type: Boolean, value: false}
    error: {type: String, value: ''}
    valid: {type: Boolean, value: true}
    validate: {type: Boolean, value: false}

  show: ->
    @validate = false
    @error = ''
    @$.dialog.opened = true

  hide: ->
    @$.dialog.opened = false

  _validate: ->
    @valid = !@$.email.invalid && !@$.password.invalid

  _login: ->
    @validate = true
    @$.email.validate()
    @$.password.validate()
    if @valid
      @error = ''
      @fire 'login'
    else
      if @$.email.invalid
        @$.email.focus()
      else
        @$.password.focus()

  _isPresent: (text) ->
    text?.length > 0

  _errorChanged: ->
    @$.password.focus()
