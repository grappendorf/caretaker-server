Polymer

  is: 'caretaker-dashboards-list'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}
    searchText: {type: String, value: ''}

  attached: ->
    @async ->
      @$.table.load()

  _edit: (e) ->
    @router.go "/dashboards/#{e.detail.id}"

  _new: ->
    @router.go '/dashboards/new'
