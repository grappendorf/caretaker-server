id = 1

Polymer

  is: 'caretaker-data-action'

  properties:
    icon: {type: String, value: 'square'}
    router: {type: Object}
    routeTo: {type: String}
    name: {type: String, value: -> "#{id++}"}

  fireAction: (id) ->
    @fire 'fire', id: id
