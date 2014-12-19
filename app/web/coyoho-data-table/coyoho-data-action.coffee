id = 1


Polymer 'coyoho-data-action',

  created: ->
    @icon = 'square'
    @name = "#{id++}"

  fireAction: (id) ->
    @fire 'fire', id: id
