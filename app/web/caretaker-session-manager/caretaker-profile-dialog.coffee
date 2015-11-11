Polymer

  is: 'caretaker-profile-dialog'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    processing: {type: Boolean, value: false}
    error: {type: String, value: ''}

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
