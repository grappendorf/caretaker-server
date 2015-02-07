Polymer 'caretaker-device-scripts-list',

  ready: ->
    @$.table.load()

  edit: (e) ->
    @router.go "/device_scripts/#{e.detail.id}"

  new: ->
    @router.go '/device_scripts/new'

  toggleEnabled: (e) ->
    self = @
    item = e.detail.item
    @deviceScripts.memberAction item.id, (if item.enabled then 'disable' else 'enable'), ->
      self.$.table.load()
