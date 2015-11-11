id = 1

Polymer

  is: 'caretaker-data-column'

  properties:
    name: {type: String, value: -> "#{id++}"}
    heading: {type: String}
    width: {type: String, value: '0'}
    type: {type: String, value: 'string'}
    icon: {type: String}
    align: {type: String, value: ''}
    headerAlign: {type: String, value: ''}
    template: {type: Object}

  ready: ->
    templates = Polymer.dom(@$.content).getDistributedNodes()
    if templates.length > 0
      @type = 'template'
      @template = templates[0]
      @template.setAttribute 'id', "column-#{@name}"
