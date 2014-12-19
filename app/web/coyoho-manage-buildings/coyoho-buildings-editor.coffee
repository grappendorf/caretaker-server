Polymer 'coyoho-buildings-editor',

  idChanged: ->
    @$.editor.load @id

  back: ->
    @router.go "/buildings"
