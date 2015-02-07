Polymer 'caretaker-devices-editor',

  idChanged: ->
    @$.editor.load @id

  typeChanged: ->
    self = @
    @devices.new (item) ->
      self.$.editor.show item

  back: ->
    @router.go "/devices"
