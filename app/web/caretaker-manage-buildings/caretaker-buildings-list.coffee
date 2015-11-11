Polymer

  is: 'caretaker-buildings-list'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}
    searchText: {type: String, value: ''}

  attached: ->
    @async ->
      @$.table.load()

  _edit: (e) ->
    @router.go "/buildings/#{e.detail.id}"

  _new: ->
    @router.go '/buildings/new'

  _showFloors: (e) ->
    @router.go "/buildings/#{e.detail.id}/floors"

  _buildingsParams: (searchText) ->
    {q: searchText}
