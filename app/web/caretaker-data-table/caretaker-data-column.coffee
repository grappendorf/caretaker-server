id = 1


Polymer 'caretaker-data-column',

  created: ->
    @name = "#{id++}"
    @type = 'string'
    @heading = null
    @icon = null
    @width = '0'
    @align = ''
    @headerAlign = ''
    @template = null

  ready: ->
    templates = @$.content.getDistributedNodes()
    if templates.length > 0
      @type = 'template'
      @template = templates[0]
      @template.id = "column-#{@name}"
