Polymer 'caretaker-data-editor',

  created: ->
    @fieldsets = []
    @fields = []
    @header = null
    @item = null
    @valid = true
    @modified = false
    @processing = false

  ready: ->
    @updateFields()
    @onMutation @, ->
      @updateFields()

  updateFields: ->
    @fieldsets = []
    fieldNodes= @querySelectorAll(':scope > caretaker-data-field')
    if fieldNodes.length > 0
      @fieldsets.push
        label: null
        icon: null
        image: null
        fields: (@initField(field) for field in fieldNodes)
    fieldsetNodes = @querySelectorAll('caretaker-data-fieldset')
    for fieldset_node in fieldsetNodes
      fieldNodes = fieldset_node.querySelectorAll('caretaker-data-field')
      @fieldsets.push
        label: fieldset_node.label
        icon: fieldset_node.icon
        image: fieldset_node.image
        fields: (@initField(field) for field in fieldNodes)

  initField: (field) ->
    field.label = if field.label? then field.label else @$.i18n.t "attributes.#{field.model || @model}.#{field.name}"
    field

  show: (item) ->
    @modified = false
    @valid = true
    for fieldset in @fieldsets
      for field in fieldset.fields
        field.error = null
    @item = item

  load: (id) ->
    self = @
    @id = id
    @modified = false
    @valid = true
    for fieldset in @fieldsets
      for field in fieldset.fields
        field.error = null
    if @isValidItemId id
      @processing = true
      @resource.show id, (result) ->
        self.processing = false
        self.item = result
    else
      @item = {}

  save: ->
    self = @
    @processing = true
    if @item.id
      @resource.update @id, @item, ->
        self.processing = false
        self.modified = false
        self.fire 'data-editor-back'
      , (response)->
        for fieldset in self.fieldsets
          for field in fieldset.fields when field.name of response.errors
            field.error = response.errors[field.name]
        self.processing = false
    else
      @resource.create @item, ->
        self.processing = false
        self.modified = false
        self.fire 'data-editor-back'
      , (response)->
        for fieldset in self.fieldsets
          for field in fieldset.fields when field.name of response.errors
            field.error = response.errors[field.name]
        self.processing = false

  cancel: ->
    @fire 'data-editor-back'

  validate: ->
    @modified = true

  isValidItemId: (id) ->
    !isNaN(id)

  updateCheckField: (e) ->
    @validate()
    e.target.templateInstance.model.item.enabled = e.path[0].checked
