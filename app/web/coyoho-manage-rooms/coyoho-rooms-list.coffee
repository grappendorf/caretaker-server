Polymer 'coyoho-rooms-list',

  buildingIdChanged: ->
    @$.table.load()

  floorIdChanged: ->
    @$.table.load()

  edit: (e) ->
    @router.go "/buildings/#{@buildingId}/floors/#{@floorId}/rooms/#{e.detail.id}"

  new: ->
    @router.go "/buildings/#{@buildingId}/floors/#{@floorId}/rooms/new"

  nameOfBuilding: (names, id) ->
    building = names.filter((b) -> b.id == id)[0] if names && id
    if building then building.name else '?'

  nameOfFloor: (names, id) ->
    floor = names.filter((b) -> b.id == id)[0] if names && id
    if floor then floor.name else '?'
