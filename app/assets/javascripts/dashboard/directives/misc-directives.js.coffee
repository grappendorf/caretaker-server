angular.module('dashboard').directive 'ngBlur', ->
	(scope, elem, attrs) ->
		elem.bind 'blur', ->
			scope.$apply(attrs.ngBlur)

angular.module('dashboard').directive 'focusMe', ($timeout) ->
	scope: { trigger: '@focusMe' }
	link: (scope, element, attrs, model) ->
		$timeout -> element[0].focus()
