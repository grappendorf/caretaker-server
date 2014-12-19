Polymer 'coyoho-dashboards-list',

  ready: ->
    @$.table.load()

  edit: (e) ->
    @router.go "/dashboards/#{e.detail.id}"

  new: ->
    @router.go '/dashboards/new'
