Polymer

  is: 'caretaker-app-toolbar'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    user: {type: Object}
    token: {type: String}

  _toolbarTitle: (appModule) ->
    if appModule != 'misc' then appModule else ''
