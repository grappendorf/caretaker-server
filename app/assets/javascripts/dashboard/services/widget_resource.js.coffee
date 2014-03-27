angular.module 'dashboard'
.factory 'Widget', ($resource) ->
		$resource '/dashboards/:dashboard_id/:type/:id.json', { id: '@id', type: 'widgets', dashboard_id: '@dashboard_id' },
			'create': {  method: 'POST', params: { type: '@type' } }
			'index': { method: 'GET', isArray: true }
			'show': { method: 'GET', isArray: false }
			'update': { method: 'PUT' }
			'destroy': { method: 'DELETE' }
