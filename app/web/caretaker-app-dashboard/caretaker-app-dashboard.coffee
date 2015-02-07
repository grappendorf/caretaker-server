Polymer 'caretaker-app-dashboard',

  ready: ->
    @app = document.querySelector('caretaker-app')

  launch: (e) ->
    @app.$.router.go "/#{e.detail}"
