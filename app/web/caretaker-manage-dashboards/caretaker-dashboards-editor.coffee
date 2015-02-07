Polymer 'caretaker-dashboards-editor',

  idChanged: ->
    @$.editor.load @id

  back: ->
    @router.go "/dashboards"
