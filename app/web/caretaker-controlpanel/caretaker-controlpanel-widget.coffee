Polymer 'caretaker-controlpanel-widget',

  editProperties: ->
    @fire 'edit-widget-properties', @widget

  delete: ->
    @fire 'delete-widget', @widget
