angular.module 'dashboard'
.controller 'DashboardPropertiesDialogController',
	($scope, $http, $modalInstance, dashboard) ->

		$scope.action = 'edit'

		$scope.dashboard =
			name: dashboard.name

		$scope.ok = ->
			$modalInstance.close($scope.dashboard)

		$scope.cancel = ->
			$modalInstance.dismiss()
