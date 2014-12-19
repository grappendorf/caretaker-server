Polymer 'coyoho-password-dialog',

  created: ->
    @password = ''
    @passwordConfirm = ''
    @valid = false
    @processing = false
    @error = ''

  show: ->
    @$.dialog.opened = true

  hide: ->
    @$.dialog.opened = false

  validate: ->
    @valid =
        @$.password.value.length > 0 &&
            @$.passwordConfirm.value is @$.password.value

  submit: ->
    @error = ''
    @fire 'submit',
      password: @password
