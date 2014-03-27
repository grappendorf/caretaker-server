angular.module 'dashboard'
.directive "gridster",
	() ->
		restrict: "E"
		transclude: true
		replace: true
		template: '<div class="gridster"><ul><div ng-transclude/></ul></div>'

		link: (scope, element, attrs, controller) ->
			controller.init element

		controller: ($scope) ->
			gridster = null

			init: (elem) ->

				gridster = elem.find("ul").gridster(
					# TODO: Make the options configurable
					min_cols: 12
					widget_margins: [8, 8]
					widget_base_dimensions: [160, 160]
					avoid_overlapped_widgets: true

					draggable:
						start: (event) ->
							$scope.widgetDragBegin $(event.target).parents('li.ng-scope')
						stop: (event) ->
							$scope.disableDrag()
							$scope.widgetDragEnd $(event.target).parents('li.ng-scope')
							for changed in gridster.serialize_changed()
								# TODO: Make the widgetLayoutChanged function configurable through an attribute
								$scope.widgetLayoutChanged changed
							gridster.$changed = $([])

					resize:
						enabled: true
						# TODO: Make the resize callbacks configurable
						start: (event, ui, widget) ->
							$scope.widgetResizeBegin widget
						stop: (event, ui, widget) ->
							$scope.widgetResizeEnd widget
							$scope.widgetLayoutChanged gridster.serialize(widget)[0]
							for changed in gridster.serialize_changed()
								# TODO: Make the widgetLayoutChanged function configurable through an attribute
								$scope.widgetLayoutChanged changed
							gridster.$changed = $([])

					# TODO: Make the serialize_params function configurable
					serialize_params: ($w, wgd) ->
						id: $w.attr('id')
						x: wgd.col
						y: wgd.row
						width: wgd.size_x
						height: wgd.size_y

				).data('gridster')
				gridster.disable()

			add: (element, widget) ->
				gridster.add_widget element, widget.width, widget.height, widget.x, widget.y

			remove: (element) ->
				gridster.remove_widget element

			resize: (element, width, height) ->
				gridster.resize_widget element, width, height

			gridster: -> gridster

angular.module 'dashboard'
.directive "gridsterWidget",
	() ->
		restrict: "E"
		require: "^gridster"
		transclude: true
		replace: true
		template: '<li ng-transclude></li>'

		link: (scope, element, attrs, gridsterController, transclude) ->
			scope.$watch 'widget', (newWidget, oldWidget) ->
				if newWidget.width != oldWidget.width || newWidget.height != oldWidget.height
					gridsterController.resize element, newWidget.width, newWidget.height
					scope.widgetLayoutChanged newWidget
					for changed in gridsterController.gridster().serialize_changed()
						scope.widgetLayoutChanged changed
			, true
			gridsterController.add element, scope.widget
			element.bind "$destroy", () ->
				gridsterController.remove element
