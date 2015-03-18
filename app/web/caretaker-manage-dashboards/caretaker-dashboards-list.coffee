Polymer 'caretaker-dashboards-list',

  tokenChanged: ->
    @$.table.load()

  edit: (e) ->
    @router.go "/dashboards/#{e.detail.id}"

  new: ->
    @router.go '/dashboards/new'
