id = 1


Polymer 'caretaker-data-action',

  created: ->
    @icon = 'square'
    @name = "#{id++}"

  fireAction: (id) ->
    @fire 'fire', id: id
