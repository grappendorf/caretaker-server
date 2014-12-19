Polymer 'coyoho-widget-reflowovendevice',

  ready: ->
    new Chartist.Line @$.chart,
      labels: ['0s', '10s', '20s', '30s', '40s'],
      series: [
        [12, 9, 7, 8, 5],
        [2, 1, 3.5, 7, 3],
        [1, 3, 4, 5, 6]
      ]

  #angular.module 'dashboard'
  #.controller 'ReflowOvenDeviceWidgetController',
  #  ($scope) ->
  #
  #    MAX_MEASUREMENTS = 10 * 60
  #
  #    last_temperature_timestamp = null
  #
  #    $scope.device = $scope.widget.device
  #    $scope.mode = 'Unknown'
  #    $scope.state = 'Unknown'
  #    $scope.heater = false
  #    $scope.fan = false
  #    $scope.chart =
  #      options:
  #        chart:
  #          type: 'area'
  #          animation: false
  #        legend:
  #          enabled: false
  #        plotOptions:
  #          area:
  #            fillColor:
  #              linearGradient: {x1: 0, y1: 0, x2: 0, y2: 1}
  #              stops: [
  #                [0, '#f00'],
  #                [1, '#faa']
  #              ]
  #            lineWidth: 2
  #            marker:
  #              enabled: false
  #            shadow: false
  #            states:
  #              hover:
  #                lineWidth: 1
  #            threshold: null
  #      title:
  #        text: 'Temperature'
  #      xAxis:
  #        title:
  #          text: 'Time[s]'
  #      yAxis:
  #        title:
  #          text: 'Temp °C'
  #        min: 0
  #        max: 300
  #      series: [
  #        data: []
  #        color: '#c00'
  #        name: 'Temp'
  #      ]
  #      loading: false
  #
  #    $scope.update = (data) ->
  #      $scope.$apply ->
  #        if data.state.temperature.timestamp != last_temperature_timestamp
  #          last_temperature_timestamp = data.state.temperature.timestamp
  #          if $scope.chart.series[0].data.length > MAX_MEASUREMENTS
  #            $scope.chart.series[0].data = $scope.chart.series[0].data.slice(-MAX_MEASUREMENTS)
  #          $scope.chart.series[0].data.push data.state.temperature.value
  #          $scope.temperature = data.state.temperature.value
  #        $scope.mode = ['Unknwon', 'Off', 'Reflow', 'Manual',
  #                       'Cool'][if data.state.mode? then data.state.mode + 1 else 0]
  #        $scope.state = ['Unknown', 'Idle', 'Error', 'Set', 'Heat', 'Pre-cool', 'Pre-heat', 'Soak',
  #                        'Reflow', 'Reflow cool', 'Cool',
  #                        'Complete'][if data.state.state? then data.state.state + 1 else 0]
  #        $scope.heater = data.state.heater
  #        $scope.fan = data.state.fan
  #
  #    $scope.start = ->
  #      $scope.chart.series[0].data = []
  #      $scope.sendDeviceState $scope.device.id, {action: 'start'}
  #
  #    $scope.cool = ->
  #      $scope.sendDeviceState $scope.device.id, {action: 'cool'}
  #
  #    $scope.off = ->
  #      $scope.sendDeviceState $scope.device.id, {action: 'off'}
  #