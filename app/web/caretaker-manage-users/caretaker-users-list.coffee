Polymer 'caretaker-users-list',

  tokenChanged: ->
    @$.table.load()

  edit: (e) ->
    @router.go "/users/#{e.detail.id}"

  new: ->
    @router.go '/users/new'
