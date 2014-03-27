angular.module('dashboard').filter 'i18n', ($sce) ->
	(input) ->
		I18n.t input
