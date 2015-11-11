Polymer

  is: 'caretaker-rooms-list'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}
    searchText: {type: String, value: ''}
    buildingId: {type: String, observer: '_deselectFloorsNames'}
    floorId: {type: String}

  observers: [
    '_load(buildingId, floorId, searchText, apiUrl, token)'
  ]

  _load: ->
    @$.table.load()

  _deselectFloorsNames: ->
    @floorsNames = [] unless @buildingId
    @$.floors.deselect()

  _roomsParams: (buildingId, floorId, searchText) ->
    {buildingId: buildingId, floorId: floorId, q: searchText}

  _floorsNamesPath: (buildingId) ->
    "/buildings/#{buildingId}/floors/names"

  _nameOfBuilding: (names, id) ->
    building = names.filter((b) -> b.id == id)[0] if names && id
    building?.name || '?'

  _nameOfFloor: (names, id) ->
    floor = names.filter((b) -> b.id == id)[0] if names && id
    floor?.name || '?'

  _edit: (e) ->
    @router.go "/buildings/#{@buildingId}/floors/#{@floorId}/rooms/#{e.detail.id}"

  _new: ->
    @router.go "/buildings/#{@buildingId}/floors/#{@floorId}/rooms/new"
