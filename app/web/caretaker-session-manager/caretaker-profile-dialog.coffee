Polymer 'caretaker-profile-dialog',

  created: ->
    @email = ''
    @name = ''
    @valid = false
    @processing = false
    @error = ''

  show: ->
    @$.dialog.opened = true

  hide: ->
    @$.dialog.opened = false

  submit: ->
    @error = ''

  validate: ->
    @valid =
        @$.email.value.length > 0 && !@$.email.invalid &&
            @$.name.value.length > 0 && !@$.name.invalid
