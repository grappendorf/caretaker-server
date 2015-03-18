Polymer 'caretaker-floors-list',

  tokenChanged: ->
    @$.table.load()

  buildingIdChanged: ->
    @$.table.load() if @token

  edit: (e) ->
    @router.go "/buildings/#{@buildingId}/floors/#{e.detail.id}"

  new: ->
    @router.go "/buildings/#{@buildingId}/floors/new"

  showRooms: (e) ->
    @router.go "/buildings/#{@buildingId}/floors/#{e.detail.id}/rooms"

  nameOfBuilding: (names, id) ->
    building = names.filter((b) -> b.id == id)[0] if names && id
    if building then building.name else '?'
