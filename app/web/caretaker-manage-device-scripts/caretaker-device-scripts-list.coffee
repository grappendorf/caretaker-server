Polymer

  is: 'caretaker-device-scripts-list'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}

  attached: ->
    @async ->
      @$.table.load()

  _edit: (e) ->
    @router.go "/device_scripts/#{e.detail.id}"

  _new: ->
    @router.go '/device_scripts/new'

  _toggleEnabled: (e) ->
    item = e.detail.item
    @deviceScripts.memberAction(item.id, (if item.enabled then 'disable' else 'enable')).then =>
      @$.table.load()
