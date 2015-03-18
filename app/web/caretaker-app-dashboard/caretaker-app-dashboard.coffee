Polymer 'caretaker-app-dashboard',

  launch: (e) ->
    @router.go "/#{e.detail}"
