Polymer

  is: 'caretaker-floors-list'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}
    searchText: {type: String, value: ''}
    buildingId: {type: String}

  observers: [
    '_load(buildingId, searchText, apiUrl, token)'
  ]

  _load: ->
    @$.table.load()

  _edit: (e) ->
    @router.go "/buildings/#{@buildingId}/floors/#{e.detail.id}"

  _new: ->
    @router.go "/buildings/#{@buildingId}/floors/new"

  _showRooms: (e) ->
    @router.go "/buildings/#{@buildingId}/floors/#{e.detail.id}/rooms"

  _floorsParams: (buildingId, searchText) ->
    {buildingId: buildingId, q: searchText}

  _nameOfBuilding: (names, id) ->
    building = names.filter((b) -> b.id == id)[0] if names && id
    building?.name || '?'
