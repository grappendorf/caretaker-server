Polymer

  is: 'caretaker-users-list'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}
    searchText: {type: String, value: ''}

  observers: [
    '_load(searchText, apiUrl, token)'
  ]

  _load: ->
    @$.table.load()

  _edit: (e) ->
    @router.go "/users/#{e.detail.id}"

  _new: ->
    @router.go '/users/new'

