Polymer

  is: 'caretaker-devices-new-dialog'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    foo: {type: String, value: 'bar'}
    deviceModels:
      type: Array
      value: [
        {type: 'cipcam_devices', label: 'models.cipcam_device.one', icon: '32/camera.png'},
        {type: 'dimmer_devices', label: 'models.dimmer_device.one', icon: '32/slider.png'},
        {type: 'dimmer_rgb_devices', label: 'models.dimmer_rgb_device.one', icon: '32/slider.png'},
        {type: 'easyvr_devices', label: 'models.easyvr_device.one', icon: '32/speak.png'},
        {type: 'philips_hue_light_devices', label: 'models.philips_hue_light_device.one', icon: '32/lightbulb_on.png'},
        {type: 'reflow_oven_devices', label: 'models.reflow_oven_device.one', icon: '32/oven.png'},
        {type: 'remote_control_devices', label: 'models.remote_control_device.one', icon: '32/button_red.png'},
        {type: 'rotary_knob_devices', label: 'models.rotary_knob_device.one', icon: '32/knob.png'},
        {type: 'switch_devices', label: 'models.switch_device.one', icon: '32/lightbulb_on.png'},
        {type: 'sensor_devices', label: 'models.sensor_device.one', icon: '32/thermometer.png'}
      ]

  start: ->
    promise = new Promise (resolve, reject) =>
      @resolve = resolve
    @$.dialog.open()
    promise

  end: ->
    @async ->
      @$.dialog.close()

  _ok: ->
    @resolve @deviceModel.type

  _cancel: ->
    @end()

  validate: ->
    @valid = @deviceType?

  deviceTypeChanged: ->
    @validate()

  _iconImageUrl: (icon) ->
    "/images/#{icon}"
