angular.module 'dashboard'
.controller 'DashboardController',
	($scope, $http, $timeout, $modal, $dialogs, $location, Dashboard, Widget) ->

		websocketDispatcher = new WebSocketRails $('meta[name="x-coyoho-websocket"]').attr('content')

		loadDashboardInfos = (success, failure) ->
			$scope.dashboards = Dashboard.names {}, success, failure

		loadDashboard = (dashboard) ->
			$scope.state = 'loading'
			$location.path "/dashboards/#{dashboard.id}"
			$scope.dashboard = Dashboard.get {id: dashboard.id}
			, ->
				$scope.state = 'ok'
			, ->
				$scope.dashboard = dashboard
				$scope.state = 'error'

		loadDefaultDashboard = ->
			loadDashboard _.find $scope.dashboards, (d) -> d.default

		getWidget = (id) -> _.find $scope.dashboard.widgets, (w) -> w.id == id

		$scope.state = 'ok'

		$scope.init = (dashboard_id) ->
			$scope.state = 'loading'
			loadDashboardInfos -> loadDashboard {id: dashboard_id}
			channel = websocketDispatcher.subscribe 'devices'
			channel.bind 'state', (data) ->
				$("[data-device-id=#{data.id}]").scope().update(data)
			channel.bind 'connection', (data) ->
				$scope.$apply ->
					$("[data-device-id=#{data.id}]").scope().device.connected = data.connected

		$scope.selectDashboard = (dashboard) ->
			loadDashboard dashboard

		$scope.dashboardProperties = ->
			$modal.open(
				templateUrl: '_dashboard_properties_dialog'
				controller: 'DashboardPropertiesDialogController'
				resolve:
					dashboard: -> $scope.dashboard
			).result.then (result) ->
				Dashboard.update {id: $scope.dashboard.id}, result, ->
					loadDashboardInfos()
					$scope.dashboard.name = result.name

		$scope.reload = ->
			loadDashboard $scope.dashboard

		$scope.addWidget = ->
			$modal.open(
				templateUrl: '_device_widget_properties_dialog'
				controller: 'AddWidgetDialogController'
			).result.then (dlg_result) ->
				pos = gridster().next_position 2, 2
				widget = new Widget
					x: pos.col
					y: pos.row
					width: 2
					height: 2
					device_id: dlg_result.device.id
					title: dlg_result.title if dlg_result.title
				widget.$save {dashboard_id: $scope.dashboard.id, type: 'device_widgets'}, (result) ->
					$scope.dashboard.widgets.push Widget.get {dashboard_id: $scope.dashboard.id, id: result.id }

		$scope.removeWidget = (widget) ->
			Widget.destroy {dashboard_id: $scope.dashboard.id, id: widget.id}, ->
				$scope.dashboard.widgets = $scope.dashboard.widgets.filter (w) -> w.id != widget.id

		$scope.enableDrag = ->
			gridster().enable()

		$scope.disableDrag = ->
			gridster().disable()

		$scope.sendDeviceState = (deviceId, state) ->
			websocketDispatcher.trigger 'device.state', {id: deviceId, state: state}

		$scope.newDashboard = ->
			$modal.open(
				templateUrl: '_dashboard_properties_dialog'
				controller: 'NewDashboardDialogController'
			).result.then (result) ->
				new Dashboard(result).$save (dashboard) ->
					loadDashboardInfos()
					loadDashboard(dashboard)

		$scope.deleteDashboard = ->
			$dialogs.confirm(I18n.t('title.delete_confirmation'),
					I18n.t('message.delete_dashboard_confirmation', {name: $scope.dashboard.name}))
			.result.then ->
				Dashboard.delete {id: $scope.dashboard.id}, ->
					$scope.dashboards = $scope.dashboards.filter (d) -> d.id != $scope.dashboard.id
					loadDefaultDashboard()

		# Called by Gridster when a widget was moved or resized
		$scope.widgetLayoutChanged = (layout) ->
			widget = getWidget layout.id
			widget.x = layout.x
			widget.y = layout.y
			widget.width = layout.width
			widget.height = layout.height
			Widget.update {dashboard_id: $scope.dashboard.id, id: widget.id}, layout

		$scope.editWidgetProperties = (widget) ->
			$modal.open(
				templateUrl: '_device_widget_properties_dialog'
				controller: 'WidgetPropertiesDialogController'
				resolve:
					widget: -> widget
			).result.then (dlg_result) ->
				widget.title = dlg_result.title
				Widget.update {dashboard_id: $scope.dashboard.id, id: widget.id, title: widget.title}

		# Called by gridster when widget dragging ends
		$scope.widgetDragBegin = (widget) ->
			console.log widget
			$scope.$apply -> widget.scope().dragging = true

		# Called by gridster when widget dragging ends
		$scope.widgetDragEnd = (widget) ->
			$scope.$apply -> widget.scope().dragging = false

		# Called by gridster when widget resizing begins
		$scope.widgetResizeBegin = (widget) ->
			console.log widget
			$scope.$apply -> widget.scope().resizing = true

		# Called by gridster when widget resizing ends
		$scope.widgetResizeEnd = (widget) ->
			$scope.$apply -> widget.scope().resizing = false

angular.module 'dashboard'
.controller 'NoDashboardController',
	($scope, Dashboard) ->

		$scope.newDashboard = ->
			new Dashboard({name: 'Default', default: true}).$save (dashboard) ->
				window.location = "/dashboards/#{dashboard.id}"