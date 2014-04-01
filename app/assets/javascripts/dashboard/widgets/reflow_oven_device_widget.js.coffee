angular.module 'dashboard'
.controller 'ReflowOvenDeviceWidgetController',
($scope, $timeout) ->

	lastMeasurement = 50

	addMeasurement = ->
		lastMeasurement += -20 + (Math.random() * 40)
		lastMeasurement = Math.max 0, lastMeasurement
		if $scope.chart.series[0].data.length >= 40
			$scope.chart.series[0].data.shift()
		$scope.chart.series[0].data.push Math.round(lastMeasurement * 100) / 100
		$timeout addMeasurement, 2000

	$scope.init = ->
		$timeout addMeasurement, 2000

	$scope.chart =
		options:
			chart:
				type: 'area'
				animation: false
			legend:
				enabled: false
			plotOptions:
				area:
					fillColor:
						linearGradient: { x1: 0, y1: 0, x2: 0, y2: 1}
						stops: [
							[0, '#f00'],
							[1, '#faa']
						]
					lineWidth: 2
					marker:
						enabled: false
					shadow: false
					states:
						hover:
							lineWidth: 1
					threshold: null
		title:
			text: 'Temperature'
		xAxis:
			title:
				text: 'Time[s]'
		yAxis:
			title:
				text: 'Temp °C'
			min: 0
			max: 300
		series: [
			data: [50, 60, 80, 100, 120, 150, 180, 200, 220, 200, 180, 150, 130, 100, 50]
			color: '#c00'
			name: 'Temp'
		]
		loading: false
