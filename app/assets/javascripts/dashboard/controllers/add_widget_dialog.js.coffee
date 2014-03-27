angular.module 'dashboard'
.controller 'AddWidgetDialogController',
	($scope, $http, $modalInstance) ->

		$scope.action = 'new'

		$scope.widget =
			title: undefined
			device: undefined

		$scope.getDevices = (query) ->
			$http.get("/devices/names.json", params: {q: query}).then (res) ->
				res.data

		$scope.ok = ->
			$http.get("/devices/#{$scope.widget.device.id}.json").then (device) ->
				$scope.widget.device = device.data
				$modalInstance.close($scope.widget)

		$scope.cancel = ->
			$modalInstance.dismiss()
