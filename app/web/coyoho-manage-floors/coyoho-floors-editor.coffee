Polymer 'coyoho-floors-editor',

  idChanged: ->
    @$.editor.load @id

  back: ->
    @router.go "/buildings/#{@buildingId}/floors"

  nameOfBuilding: (names, id) ->
    id
