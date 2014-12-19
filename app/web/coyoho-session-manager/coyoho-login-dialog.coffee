Polymer 'coyoho-login-dialog',

  created: ->
    @email = ''
    @password = ''
    @valid = false
    @processing = false
    @error = ''

  show: ->
    @$.dialog.opened = true

  hide: ->
    @$.dialog.opened = false

  validate: ->
    @valid = @$.email.value.length > 0 && @$.password.value.length > 0

  login: ->
    @error = ''
    @fire 'login'
