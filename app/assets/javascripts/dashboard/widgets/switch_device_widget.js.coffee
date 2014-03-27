angular.module 'dashboard'
.controller 'SwitchDeviceWidgetController',
	($scope) ->

		$scope.device = $scope.widget.device

		total = $scope.device.num_switches
		perRow = $scope.device.switches_per_row
		$scope.rows = ((row * perRow + col for col in [0...perRow]) for row in [0...total / perRow])

		$scope.states = $scope.device.state

		$scope.classes = (['off', 'on'][state] for state in $scope.states)

		$scope.toggle = (num) ->
			$scope.sendDeviceState $scope.device.id, {num: num, value: 1 - $scope.states[num]}

		$scope.update = (data) ->
			$scope.$apply ->
				for state, num in data.state
					$scope.states[num] = state
					$scope.classes[num] = ['off', 'on'][state]
