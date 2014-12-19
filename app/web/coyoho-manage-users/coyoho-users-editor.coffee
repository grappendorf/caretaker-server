Polymer 'coyoho-users-editor',

  idChanged: ->
    @$.editor.load @id

  back: ->
    @router.go "/users"
