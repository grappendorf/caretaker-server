Polymer

  is: 'caretaker-manage-philipshue'

  behaviors: [Grapp.I18NJsBehavior]

  properties:
    token: {type: String}
    processingRegister: {type: Boolean, value: false}
    processingUnregister: {type: Boolean, value: false}
    processingSynchronize: {type: Boolean, value: false}

  _register: ->
    @processingRegister = true
    @$.registerRequest.generateRequest()

  _registered: ->
    @processingRegister = false
    @bridge = null
    @$.bridgeRequest.generateRequest()

  _error: (e) ->
    @processingRegister = false
    @processingUnregister = false
    @processingSynchronize = false
    @$.messageDialog.show I18n.t('message.philips_hue_communication_error',
      error: e.detail.response.exception)

  _unregister: ->
    @$.unregisterConfirmation.ask().then =>
      @processingUnregister = true
      @$.unregisterRequest.generateRequest()
    , ->

  _unregistered: ->
    @processingUnregister = false
    @bridge = null
    @$.bridgeRequest.generateRequest()

  _synchronize: ->
    @processingSynchronize = true
    @$.synchronizeRequest.generateRequest()

  _synchronized: ->
    @processingSynchronize = false

  _editName: (e) ->
    light = e.target.templateInstance.model.light
    @newLightName = light.name
    @$.renameLightDialog.ask().then =>
      @lightId = light.num
      @$.renameLightRequest.generateRequest()

  _renamed: ->
    @$.bridgeRequest.generateRequest()

  _renameLightPath: (lightId) ->
    "/philips_hue/lights/#{lightId}"

  _renameLightParams: (name) ->
    {name: name}

  _isBridgeConnected: (bridge) ->
    bridge && bridge.connected

  _isBridgeDisconnected: (bridge) ->
    bridge && ! bridge.connected

  _synchronizeButtonIcon: (processing) ->
    if processing then "spinner" else "retweet"

  _registerButtonIcon: (processing) ->
    if processing then "spinner" else "link"

  _unregisterButtonIcon: (processing) ->
    if processing then "spinner" else "unlink"
