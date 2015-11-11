Polymer

  is: 'caretaker-controlpanel'

  behaviors: [Grapp.I18NJsBehavior, CaretakerUtilsBehavior]

  properties:
    token: {type: String}
    id: {type: Number}
    dashboardId: {type: String, value: 'default', observer: '_dashboardIdChanged'}
    state: {type: String, value: 'ok'}
    widgetComponents: {type: Array, value: -> []}

  attached: ->
    @packery = new Packery @$.widgets,
      rowHeight: 220
      columnWidth: 200
      itemSelector: 'caretaker-controlpanel-widget'
      transitionDuration: '.2s'
      gutter: 2

    @packery.on 'dragItemPositioned', (packery, item) =>
      for item,index in @packery.getItemElements()
        if (item.widget.position != index)
          item.widget.position = index
          @widgets.update item.widget.id, position: index

    observer = new MutationObserver (mutations, observer) =>
      @packery.reloadItems()
      for item in @packery.getItemElements()
        draggability = new Draggabilly item, {handle: '[icon="square"]'}
        @packery.bindDraggabillyEvents draggability
        widgetObserver = new MutationObserver (widgetMutations, widgetObserver) =>
          if widgetMutations[0].attributeName == 'width' || widgetMutations[0].attributeName == 'height'
            @packery.layout()
        widgetObserver.observe item, {childList: false, attributes: true}
      @packery.layout()

    observer.observe @$.widgets, {childList: true, attributes: false}

  _defaultDashboardSucceeded: (e) ->
    @dashboardId = e.detail.response.id

  _dashboardSucceeded: (e) ->
    @state = 'ok'
    @dashboard = e.detail.response

  _dashboardFailed: (e) ->

  _updateDeviceState: (e) ->
    widgets = @$.widgets.querySelectorAll @_widgetComponentName(e.detail.type)
    for widget in widgets
      widget.updateState e.detail

  _dashboardIdChanged: ->
    @_loadDashboard() unless @dashboardId == 'default'

  _loadDashboard: ->
    @state = 'loading'
    @$.dashboardRequest.generateRequest()

  _editDashboard: ->
    @$.editDashboardDialog.start().then (dashboard) =>
      @dashboards.update(@dashboardId, dashboard).then (success) =>
        @$.editDashboardDialog.end()
        @$.dashboardNamesRequest.generateRequest()
      , (error) =>
        @$.editDashboardDialog.error error.errors

  _reloadDashboard: ->
    @dashboard = null
    @_loadDashboard()

  _newDashboard: ->
    @$.newDashboardDialog.start().then (dashboard) =>
      @dashboards.create(dashboard).then (success) =>
        @$.newDashboardDialog.end()
        @$.dashboardNamesRequest.generateRequest()
        @dashboardId = success.id
      , (error) =>
        @$.newDashboardDialog.error error.errors

  _deleteDashboard: ->
    message = I18n.t 'message.confirm_delete',
      model: I18n.t 'models.dashboard.one'
      name: @dashboard.name
    @$.deleteConfirmDialog.ask(message).then =>
      @dashboards.delete @dashboardId
      @$.dashboardNamesRequest.generateRequest()
      @$.defaultDashboardRequest.generateRequest()
    , ->

  _newWidget: ->
    @$.newWidgetDialog.start().then (widget) =>
      @widgets.create widget, (response) =>
        @$.newWidgetDialog.end()
        @$.dashboardRequest.generateRequest()
      , =>
        @$.newWidgetDialog.end()

  _editWidgetProperties: (e) ->
    @$.editWidgetDialog.widget = e.detail
    @$.editWidgetDialog.start().then (widget) =>
      @widgets.update widget.id, widget, =>
        @$.editWidgetDialog.end()
      , =>
        @$.editWidgetDialog.end()

  _deleteWidget: (e) ->
    message = I18n.t 'message.confirm_delete',
      model: I18n.t 'models.widget.one'
      name: e.detail.title
    @$.deleteConfirmDialog.ask(message).then =>
      @widgets.delete e.detail.id
      @reloadDashboard()
    , ->

  _updateDeviceConnection: (e) ->
    widgets = @$.widgets.querySelectorAll "caretaker-controlpanel-widget"
    for w in widgets
      w.widget.device.connected = e.detail.connected if w.widget.device.id == e.detail.id

  _isLoadingState: (state) ->
    state == 'loading'

  _isStateError: (state) ->
    state == 'error'

  _widgetTemplateBinding: (widget, websocket) ->
    {widget: widget, websocket: websocket}

  _widgetComponentName: (widgetType) ->
    "caretaker-widget-#{widgetType.toLowerCase()}"

  _dashboardRequestParams: (dashboardId) ->
    {id: dashboardId}

  _widgetsResourceParams: (dashboardId) ->
    {dashboardId: dashboardId, type: 'device_widgets'}

  _isEmptyDashboard: (state, numWidgets) ->
    state == 'ok' && numWidgets == 0

  _hasDashboards: (numDashboards) ->
    numDashboards > 0
