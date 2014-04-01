angular.module 'dashboard', ['ngSanitize', 'ngResource', 'rails', 'ui.bootstrap', 'dialogs', 'highcharts-ng']

angular.module('dashboard').config ($httpProvider, $locationProvider) ->
	$locationProvider.html5Mode true

@gridster = ->
	$('.gridster ul').gridster().data('gridster')
