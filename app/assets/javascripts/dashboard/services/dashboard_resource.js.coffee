angular.module 'dashboard'
.factory 'Dashboard',
	($resource) ->

		$resource '/dashboards/:id.json', { id: "@id" },
			'create': { method: 'POST' }
			'index': { method: 'GET', isArray: true }
			'show': { method: 'GET', isArray: false }
			'update': { method: 'PUT' }
			'destroy': { method: 'DELETE' }
			'names': { method: 'GET', url: '/dashboards/names.json', isArray: true }
