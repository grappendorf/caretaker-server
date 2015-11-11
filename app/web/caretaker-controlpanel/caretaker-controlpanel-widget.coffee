Polymer

  is: 'caretaker-controlpanel-widget'

  properties:
    widget: {type: Object}

  _editProperties: ->
    @fire 'edit-widget-properties', @widget

  _delete: ->
    @fire 'delete-widget', @widget

  _connectionIcon: (connected) ->
    if connected then 'flash' else 'square-o'
