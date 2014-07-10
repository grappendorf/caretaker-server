angular.module 'dashboard'
.controller 'DimmerRgbDeviceWidgetController',
	($scope, $element, $http, $timeout) ->

		$scope.device = $scope.widget.device

		[$scope.red, $scope.green, $scope.blue] = $scope.device.state

		$scope.manualRedMove = false
		$scope.manualGreenMove = false
		$scope.manualBlueMove = false

		$element.find('.dimmer-red-value').slider
			min: 0
			max: 255
			value: $scope.red
			start: -> $scope.manualRedMove = true
			stop: -> $scope.manualRedMove = false
			slide: (event, ui) ->
				$scope.red = ui.value
				updateColor()
				if $scope.manualRedMove
					$timeout ->
						$scope.sendDeviceState $scope.device.id, { red: $scope.red }

		$element.find('.dimmer-green-value').slider
			min: 0
			max: 255
			value: $scope.green
			start: -> $scope.manualGreenMove = true
			stop: -> $scope.manualGreenMove = false
			slide: (event, ui) ->
				$scope.green = ui.value
				updateColor()
				if $scope.manualGreenMove
					$timeout ->
						$scope.sendDeviceState $scope.device.id, { green: $scope.green }

		$element.find('.dimmer-blue-value').slider
			min: 0
			max: 255
			value: $scope.blue
			start: -> $scope.manualBlueMove = true
			stop: -> $scope.manualBlueMove = false
			slide: (event, ui) ->
				$scope.blue = ui.value
				updateColor()
				if $scope.manualBlueMove
					$timeout ->
						$scope.sendDeviceState $scope.device.id, { blue: $scope.blue }

		$element.find('.dimmer-color').css('background', "rgb(#{$scope.red},#{$scope.green},#{$scope.blue})")

		$scope.update = (data) ->
			unless $scope.manualRedMove || $scope.manualGreenMove || $scope.manualBlueMove
				$scope.$apply ->
					[$scope.red, $scope.green, $scope.blue] = data.state
					$element.find('.dimmer-red-value').slider({min: 0, max: 255, value: $scope.red})
					$element.find('.dimmer-green-value').slider({min: 0, max: 255, value: $scope.green})
					$element.find('.dimmer-blue-value').slider({min: 0, max: 255, value: $scope.blue})
					updateColor()

		updateColor = ->
			$element.find('.dimmer-color').css('background', "rgb(#{$scope.red},#{$scope.green},#{$scope.blue})")
