Polymer 'caretaker-controlpanel',

  created: ->
    @dashboardId = 'default'
    @state = 'ok'

  domReady: ->
    @$.dashboardNamesRequest.go()

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
        draggability = new Draggabilly item, {handle: ':host /deep/ [icon="square"]'}
        @packery.bindDraggabillyEvents draggability
        widgetObserver = new MutationObserver (widgetMutations, widgetObserver) =>
          if widgetMutations[0].attributeName == 'width' || widgetMutations[0].attributeName == 'height'
            @packery.layout()
        widgetObserver.observe item, {childList: false, attributes: true}
      @packery.layout()

    observer.observe @$.widgets, {childList: true, attributes: false}

  defaultDashboardSucceeded: (e) ->
    @dashboardId = e.detail.response.id

  dashboardSucceeded: (e) ->
    @state = 'ok'
    @dashboard = e.detail.response

  updateDeviceState: (e) ->
    widgets = @$.widgets.querySelectorAll "[type=#{e.detail.type}Widget] #content"
    for widget in widgets
      widget.updateState e.detail

  dashboardIdChanged: ->
    @loadDashboard()

  loadDashboard: ->
    @state = 'loading'
    @$.dashboardRequest.go()

  editDashboard: ->
    self = @
    @$.editDashboardDialog.start().then (dashboard) ->
      self.dashboards.update self.dashboardId, dashboard, (response) ->
        self.$.editDashboardDialog.end()
        self.$.dashboardNamesRequest.go()
      , (response) ->
        self.$.editDashboardDialog.error response.errors

  reloadDashboard: ->
    @dashboard = null
    @loadDashboard()

  newDashboard: ->
    self = @
    @$.newDashboardDialog.start().then (dashboard) ->
      self.dashboards.create dashboard, (response) ->
        self.$.newDashboardDialog.end()
        self.$.dashboardNamesRequest.go()
        self.dashboardId = response.id
      , (response) ->
        self.$.newDashboardDialog.error response.message

  deleteDashboard: ->
    self = @
    message = I18n.t 'message.confirm_delete',
      model: I18n.t 'models.dashboard.one'
      name: @dashboard.name
    @$.deleteConfirmDialog.ask(message).then ->
      self.dashboards.delete self.dashboardId
      self.$.dashboardNamesRequest.go()
      self.$.defaultDashboardRequest.go()
    , ->

  newWidget: ->
    self = @
    @$.newWidgetDialog.start().then (widget) ->
      self.widgets.create widget, (response) ->
        self.$.newWidgetDialog.end()
        self.$.dashboardRequest.go()
      , ->
        self.$.newWidgetDialog.end()

  editWidgetProperties: (e) ->
    self = @
    @$.editWidgetDialog.widget = e.detail
    @$.editWidgetDialog.start().then (widget) ->
      self.widgets.update widget.id, widget, ->
        self.$.editWidgetDialog.end()
      , ->
        self.$.editWidgetDialog.end()

  deleteWidget: (e) ->
    self = @
    message = I18n.t 'message.confirm_delete',
      model: I18n.t 'models.widget.one'
      name: e.detail.title
    @$.deleteConfirmDialog.ask(message).then ->
      self.widgets.delete e.detail.id
      self.reloadDashboard()
    , ->

  updateDeviceConnection: (e) ->
    widgets = @$.widgets.querySelectorAll "caretaker-controlpanel-widget"
    for w in widgets
      w.widget.device.connected = e.detail.connected if w.widget.device.id == e.detail.id
