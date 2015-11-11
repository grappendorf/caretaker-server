Polymer

  is: 'caretaker-floors-editor'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}
    id: {type: Number}

  observers: [
    '_load(id, apiUrl)'
  ]

  _load: ->
    @$.editor.load @id

  _back: ->
    @router.go "/buildings/#{@buildingId}/floors"

  _floorsParams: (buildingId) ->
    {buildingId: buildingId}

  _buildingNamePath: (buildingId) ->
    "/buildings/#{buildingId}/name"
