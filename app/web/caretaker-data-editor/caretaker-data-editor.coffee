Polymer

  is: 'caretaker-data-editor'

  behaviors: [Grapp.I18NJsBehavior, CaretakerUtilsBehavior]

  properties:
    resource: {type: Object}
    model: {type: String}
    header: {type: String}
    fieldsets: {type: Array, value: -> []}
    fields: {type: Array, value: []}
    valid: {type: Boolean, value: false}
    modified: {type: Boolean, value: false}
    processing: {type: Boolean, value: false}
    item: {type: Object, notify: true}

  attached: ->
    @updateFields()

  load: (id) ->
    @id = id
    @modified = false
    @valid = true
    for fieldset in @fieldsets
      for field in fieldset.fields
        field.error = null
    if @_isValidItemId id
      @processing = true
      @resource.show(id).then (result) =>
        @processing = false
        @item = result.data
    else
      @item = {}

  show: (item) ->
    @modified = false
    @valid = true
    for fieldset in @fieldsets
      for field in fieldset.fields
        field.error = null
    @item = item

  updateFields: ->
    @fieldsets = []
    fieldNodes = (node for node in Polymer.dom(@).childNodes when node.nodeName == 'CARETAKER-DATA-FIELD')
    if fieldNodes.length > 0
      @fieldsets.push
        label: null
        icon: null
        image: null
        fields: (@_initField(field) for field in fieldNodes)
    fieldsetNodes = Polymer.dom(@).querySelectorAll('caretaker-data-fieldset')
    for fieldsetNode in fieldsetNodes when !fieldsetNode.optional || fieldsetNode.enabled
      fieldNodes = fieldsetNode.querySelectorAll('caretaker-data-field')
      @fieldsets.push
        label: fieldsetNode.label
        icon: fieldsetNode.icon
        image: fieldsetNode.image
        fields: (@_initField(field) for field in fieldNodes)

  _initField: (field) ->
    field.label = if field.label? then field.label else @i18n("attributes.#{field.model || @model}.#{field.name}")
    field

  _save: ->
    @processing = true
    if @item.id
      @resource.update(@id, @item).then =>
        @processing = false
        @modified = false
        @fire 'data-editor-back'
      , (response) =>
        console.log '*'
        for fieldset, fieldsetIdx in @fieldsets
          for field, fieldIdx in fieldset.fields when field.name of response.data.errors
            @set "fieldsets.#{fieldsetIdx}.fields.#{fieldIdx}.error", response.data.errors[field.name]
        @processing = false
    else
      @resource.create(@item).then =>
        @processing = false
        @modified = false
        @fire 'data-editor-back'
      , (response) =>
        for fieldset, fieldsetIdx in @fieldsets
          for field, fieldIdx in fieldset.fields when field.name of response.data.errors
            @set "fieldsets.#{fieldsetIdx}.fields.#{fieldIdx}.error", response.data.errors[field.name]
        @processing = false

  _cancel: ->
    @fire 'data-editor-back'

  _validate: ->
    @modified = true

  _isValidItemId: (id) ->
    !isNaN(id)

  _fieldClass: (error) ->
    'form-group' + (if error then ' has-error' else '')

  _itemHeader: (item, header) ->
    item[header]

  _hasFieldsetLegend: (fieldset) ->
    fieldset.label || fieldset.icon || fieldset.image

  _hasNoFields: (fieldset) ->
    fieldset.fields.length == 0

  _itemAttribute: (item, key) ->
    item[key]

  _canSave: (modified, valid) ->
    modified && valid

  _updateStringAttribute: (e) ->
    @set "item.#{e.model.field.name}", e.target.value
    @_validate()

  _updateCheckAttribute: (e) ->
    @set "item.#{e.model.field.name}", e.target.checked
    @_validate()
