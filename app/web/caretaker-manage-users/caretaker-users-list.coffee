Polymer 'caretaker-users-list',

  domReady: ->
    console.log @token
    @$.table.load()

  edit: (e) ->
    @router.go "/users/#{e.detail.id}"

  new: ->
    @router.go '/users/new'
