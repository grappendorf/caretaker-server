Polymer 'caretaker-rooms-list',

  domReady: ->
    @$.table.load()

  buildingIdChanged: ->
    @$.table.load() if @token
    @floorsNames = null unless @buildingId

  floorIdChanged: ->
    @$.table.load() if @token

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
