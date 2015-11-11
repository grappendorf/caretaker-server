Polymer

  is: 'caretaker-password-dialog',

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    password: {type: String, value: '', notify: true, observer: '_passwordChanged'}
    processing: {type: Boolean, value: false}
    error: {type: String, value: ''}

  show: ->
    promise = new Promise ((resolve, reject) ->
      @resolve = resolve
      @reject = reject
    ).bind @
    @$.dialog.opened = true
    promise

  hide: ->
    @$.dialog.opened = false

  _isPresent: (text) ->
    text?.length > 0

  _passwordConfirmPattern: (password) ->
    password

  _passwordChanged: ->
    @$.passwordConfirm.validate()

  _validate: ->
    @valid = !@$.password.invalid && !@$.passwordConfirm.invalid

  _submit: ->
    @error = ''
    @resolve(@password)
