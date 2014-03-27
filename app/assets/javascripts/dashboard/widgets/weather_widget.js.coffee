angular.module 'dashboard'
.controller 'WeatherWidgetController',
	($scope) ->

		$.simpleWeather
			zipcode: ''
			woeid: '645458'
			location: ''
			unit: 'f'
			success: (weather) ->
				html = '<h2>' + weather.temp + '&deg;' + weather.units.temp + '</h2>'
				html += '<ul><li>' + weather.city + ', ' + weather.region + '</li>'
				html += '<li class="currently">' + weather.currently + '</li>'
				html += '<li>' + weather.tempAlt + '&deg;C</li></ul>'
				$("##{$scope.widget.id} .simple-weather").html(html)
			error: (error) ->
				$("##{$scope.widget.id} .simple-weather").html('<p>' + error + '</p>')
