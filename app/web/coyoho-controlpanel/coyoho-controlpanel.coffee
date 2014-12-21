Polymer 'coyoho-controlpanel',

  created: ->
    @dashboardId = 'default'
    @dashboard = null
    @state = 'ok'

  ready: ->
    @$.dashboardNamesRequest.go()
    @onMutation @$.widgets, ->
      @packery.reloadItems()
      @packery.layout()
      for item in @packery.getItemElements()
        draggability = new Draggabilly item, {handle: '* /deep/ [icon="square"]'}
        @packery.bindDraggabillyEvents draggability

  domReady: ->
    @packery = new Packery @$.widgets,
      rowHeight: 320
      columnWidth: 320
      itemSelector: 'coyoho-controlpanel-widget'
      isInitLayout: true
      transitionDuration: '.2s'
      gutter: 4

    @packery.on 'dragItemPositioned', ->
      console.log 'widget moved'

  defaultDashboardSucceeded: (e) ->
    @dashboardId = e.detail.response.id

  dashboardSucceeded: (e) ->
    @state = 'ok'
    @dashboard = e.detail.response

  deviceStateRecieved: (e) ->
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
    @deleteConfirmMessage = I18n.t 'message.confirm_delete',
      model: I18n.t 'models.dashboard.one'
      name: @dashboard.name
    @$.deleteConfirmDialog.ask().then ->
      self.dashboards.delete self.dashboardId
      self.$.dashboardNamesRequest.go()
      self.$.defaultDashboardRequest.go()

  newWidget: ->
    self = @
    @$.newWidgetDialog.start().then (widget) ->
      self.widgets.create widget, (response) ->
        self.$.newWidgetDialog.end()
        self.$.dashboardRequest.go()
      ,
        self.$.newWidgetDialog.end()

  editWidgetProperties: (e) ->
    self = @
    @$.editWidgetDialog.widget = e.detail
    @$.editWidgetDialog.start().then (widget) ->
      self.widgets.update widget.id, widget, ->
        self.$.editWidgetDialog.end()
      ,
        self.$.editWidgetDialog.end()

  deleteWidget: (e) ->
    self = @
    @deleteConfirmMessage = I18n.t 'message.confirm_delete',
      model: I18n.t 'models.widget.one'
      name: e.detail.title
    @$.deleteConfirmDialog.ask().then ->
      self.widgets.delete e.detail.id
      self.reloadDashboard()
