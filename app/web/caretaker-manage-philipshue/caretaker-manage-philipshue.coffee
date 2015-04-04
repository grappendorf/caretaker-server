Polymer 'caretaker-manage-philipshue',

  created: ->
    @processingRegister = false
    @processingUnregister = false
    @processingSynchronize = false

  register: ->
    @processingRegister = true
    @$.registerRequest.go()

  registered: ->
    @processingRegister = false
    @bridge = null
    @$.bridgeRequest.go()

  error: (e) ->
    @processingRegister = false
    @processingUnregister = false
    @processingSynchronize = false
    @$.messageDialog.show I18n.t('message.philips_hue_communication_error',
      error: e.detail.response.exception)

  unregister: ->
    @$.unregisterConfirmation.ask().then =>
      @processingUnregister = true
      @$.unregisterRequest.go()
    , ->

  unregistered: ->
    @processingUnregister = false
    @bridge = null
    @$.bridgeRequest.go()

  synchronize: ->
    @processingSynchronize = true
    @$.synchronizeRequest.go()

  synchronized: ->
    @processingSynchronize = false

  editName: (e) ->
    light = e.target.templateInstance.model.light
    @newLightName = light.name
    @$.renameLightDialog.ask().then =>
      @lightId = light.num
      @$.renameLightRequest.go()

  renamed: ->
    @$.bridgeRequest.go()
