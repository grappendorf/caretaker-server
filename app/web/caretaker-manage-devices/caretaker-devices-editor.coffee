Polymer

  is: 'caretaker-devices-editor'

  behaviors: [Grapp.I18NJsBehavior, CaretakerUtilsBehavior]

  properties:
    token: {type: String}
    id: {type: Number}

  observers: [
    '_load(apiUrl, id)'
    '_newDevice(apiUrl, type)'
    '_updateFields(device.type)'
  ]

  _load: ->
    @$.editor.load @id

  _newDevice: ->
    @devices.new().then (success) =>
      @$.editor.show success.data

  _back: ->
    @router.go "/devices"

  _devicesParams: (type) ->
    {type: type}

  _imagePath: (imageName) ->
    "/images/#{imageName}"

  _updateFields: (deviceType) ->
    @$.editor.updateFields()
