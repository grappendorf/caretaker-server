Polymer 'caretaker-users-editor',

  idChanged: ->
    @$.editor.load @id

  back: ->
    @router.go "/users"
