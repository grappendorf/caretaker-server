Polymer 'caretaker-devices-new-dialog',

  created: ->
    # TODO: Retrieve device types from server
    @deviceTypes = [
      {type: 'camera_devices', label: 'models.camera_device.one', icon: '32/camera.png'},
      {type: 'dimmer_devices', label: 'models.dimmer_device.one', icon: '32/mixer.png'},
      {type: 'dimmer_rgb_devices', label: 'models.dimmer_rgb_device.one', icon: '32/mixer.png'},
      {type: 'easyvr_devices', label: 'models.easyvr_device.one', icon: '32/gamepad.png'},
      {type: 'ip_camera_devices', label: 'models.ip_camera_device.one', icon: '32/camera.png'},
      {type: 'reflow_oven_devices', label: 'models.reflow_oven_device.one', icon: '32/oven.png'},
      {type: 'remote_control_devices', label: 'models.remote_control_device.one', icon: '32/gamepad.png'},
      {type: 'robot_devices', label: 'models.robot_device.one', icon: '32/cat.png'},
      {type: 'switch_devices', label: 'models.switch_device.one', icon: '32/joystick.png'}
    ]

  start: ->
    promise = new Promise ((resolve, reject) ->
      @resolve = resolve
    ).bind(@)
    @$.dialog.open()
    promise

  end: ->
    @async -> @$.dialog.close()

  ok: ->
    @resolve @deviceType.type

  cancel: ->
    @end()

  validate: ->
    @valid = @deviceType?

  deviceTypeChanged: ->
    @validate()