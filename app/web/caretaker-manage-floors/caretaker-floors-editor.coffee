Polymer 'caretaker-floors-editor',

  idChanged: ->
    @$.editor.load @id

  back: ->
    @router.go "/buildings/#{@buildingId}/floors"
