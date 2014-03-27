angular.module 'dashboard'
.controller 'WidgetPropertiesDialogController',
	($scope, $http, $modalInstance, widget) ->

		$scope.action = 'edit'

		$scope.widget =
			title: widget.title
			device: widget.device

		$scope.ok = ->
			$modalInstance.close($scope.widget)

		$scope.cancel = ->
			$modalInstance.dismiss()
