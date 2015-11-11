Polymer

  is: 'caretaker-rooms-editor'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}
    id: {type: String}
    buildingId: {type: String}
    floorId: {type: String}

  observers: [
    '_load(id, buildingId, floorId, apiUrl)'
  ]

  _load: ->
    @$.editor.load @id

  _roomsParams: (buildingId, floorId) ->
    {buildingId: buildingId, floorId: floorId}

  _buildingNamePath: (buildingId) ->
    "/buildings/#{buildingId}/name"

  _floorNamePath: (buildingId, floorId) ->
    "/buildings/#{buildingId}/floors/#{floorId}/name"

  _back: ->
    @router.go "/buildings/#{@buildingId}/floors/#{@floorId}/rooms"
