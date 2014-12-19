Polymer 'coyoho-controlpanel-widget',

  editProperties: ->
    @fire 'edit-widget-properties', @widget

  delete: ->
    @fire 'delete-widget', @widget
