angular.module 'dashboard'
.controller 'NewDashboardDialogController',
	($scope, $http, $modalInstance) ->

		$scope.action = 'new'

		$scope.dashboard =
			name: undefined

		$scope.ok = ->
			$modalInstance.close($scope.dashboard)

		$scope.cancel = ->
			$modalInstance.dismiss()
