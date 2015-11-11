Polymer

  is: 'caretaker-app-dashboard'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    user: {type: Object}
    token: {type: String}
    router: {type: Object}

  _launch: (e) ->
    @router.go "/#{e.detail}"
