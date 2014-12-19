Polymer 'coyoho-app-dashboard',

  ready: ->
    @app = document.querySelector('coyoho-app')

  launch: (e) ->
    @app.$.router.go "/#{e.detail}"
