Polymer

  is: 'caretaker-buildings-editor'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}
    id: {type: Number}

  observers: [
    '_load(id, apiUrl)'
  ]

  _load: ->
    @$.editor.load @id

  _back: ->
    @router.go "/buildings"
