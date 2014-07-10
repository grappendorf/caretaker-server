angular.module 'dashboard'
.controller 'DimmerDeviceWidgetController',
	($scope, $element, $http, $timeout) ->

		$scope.device = $scope.widget.device

		$scope.value = $scope.device.state

		$scope.manualSliderMove = false

		$element.find('.dimmer-value').slider
			min: 0
			max: 255
			value: $scope.value
			start: -> $scope.manualSliderMove = true
			stop: -> $scope.manualSliderMove = false
			slide: (event, ui) ->
				if $scope.manualSliderMove
					$timeout ->
						$scope.sendDeviceState $scope.device.id, { value: ui.value }

		$scope.update = (data) ->
			unless $scope.manualSliderMove
				$scope.$apply ->
					$scope.value = data.state
					$element.find('.dimmer-value').slider('value', $scope.value)
