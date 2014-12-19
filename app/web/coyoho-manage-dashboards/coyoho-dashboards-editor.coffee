Polymer 'coyoho-dashboards-editor',

  idChanged: ->
    @$.editor.load @id

  back: ->
    @router.go "/dashboards"
