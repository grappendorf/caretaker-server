angular.module 'dashboard'
.controller 'DimmerDeviceWidgetController',
	($scope, $element, $http, $timeout) ->

		$scope.device = $scope.widget.device

		$scope.value = $scope.device.state

		$element.find('.dimmer-value').slider
			min: 0
			max: 255
			value: $scope.value
			slide: (event, ui) ->
				if event.originalEvent
					$timeout ->
						$scope.sendDeviceState $scope.device.id, { value: ui.value }

		$scope.update = (data) ->
			$scope.$apply ->
				$scope.value = data.state
				$element.find('.dimmer-value').slider('value', $scope.value)
