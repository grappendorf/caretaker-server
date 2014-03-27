angular.module 'dashboard'
.controller 'DimmerRgbDeviceWidgetController',
	($scope, $element, $http, $timeout) ->

		$scope.device = $scope.widget.device

		[$scope.red, $scope.green, $scope.blue] = $scope.device.state

		$element.find('.dimmer-red-value').slider
			min: 0
			max: 255
			value: $scope.red
			slide: (event, ui) ->
				if event.originalEvent
					$timeout ->
						$scope.sendDeviceState $scope.device.id, { red: ui.value }

		$element.find('.dimmer-green-value').slider
			min: 0
			max: 255
			value: $scope.green
			slide: (event, ui) ->
				if event.originalEvent
					$timeout ->
						$scope.sendDeviceState $scope.device.id, { green: ui.value }

		$element.find('.dimmer-blue-value').slider
			min: 0
			max: 255
			value: $scope.blue
			slide: (event, ui) ->
				if event.originalEvent
					$timeout ->
						$scope.sendDeviceState $scope.device.id, { blue: ui.value }

		$element.find('.dimmer-color').css('background', "rgb(#{$scope.red},#{$scope.green},#{$scope.blue})")

		$scope.update = (data) ->
			$scope.$apply ->
				[$scope.red, $scope.green, $scope.blue] = data.state
				$element.find('.dimmer-red-value').slider({min: 0, max: 255, value: $scope.red})
				$element.find('.dimmer-green-value').slider({min: 0, max: 255, value: $scope.green})
				$element.find('.dimmer-blue-value').slider({min: 0, max: 255, value: $scope.blue})
				$element.find('.dimmer-color').css('background', "rgb(#{$scope.red},#{$scope.green},#{$scope.blue})")
