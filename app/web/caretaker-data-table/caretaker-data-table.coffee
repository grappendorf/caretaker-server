eventToItemId = (e) ->
  rowNode = e.target.parentNode
  rowNode = rowNode.parentNode while rowNode.localName != 'tr'
  rowNode.attributes['data-item-id'].value

Polymer

  is: 'caretaker-data-table'

  behaviors: [Grapp.I18NJsBehavior, CaretakerUtilsBehavior]

  properties:
    data: {type: Array, value: -> []}
    resource: {type: Object}
    model: {type: String}
    router: {type: Object}
    searchText: {type: String, value: '', notify: true, observer: '_searchTextChanged'}
    realtimeSearch: {type: Boolean, value: false}
    titleAttribute: {type: String, value: 'name'}
    columns: {type: Array, value: -> []}
    actions: {type: Array, value: -> []}
    selectedId: {type: String, value: null}

  attached: ->
    column_nodes = Polymer.dom(@).querySelectorAll('caretaker-data-column')
    @columns = (@initColumn(column) for column in column_nodes)
    action_nodes = Polymer.dom(@).querySelectorAll('caretaker-data-action')
    @actions = (action for action in action_nodes)

  initColumn: (column) ->
    column.heading = if column.heading? then column.heading else @i18n("attributes.#{@model}.#{column.name}")
    column.thClass = ("width-#{width}" for width in column.width.split(' ')).join ' '
    column.thClass += " #{column.headerAlign}" if column.headerAlign
    column.tdClass = column.align
    if column.type == 'template'
      Polymer.dom(@root).appendChild column.template
    column

  load: ->
    @resource.index().then (result) =>
      @data = result.data

  _attribute: (item, attr) ->
    ([item].concat(attr.split('.')).reduce (i, p) -> i[p]) || ''

  _attributeCheckIcon: (item, attr) ->
    if @_attribute(item, attr) then 'check-square-o' else 'square-o'

  _attributeDate: (item, attr) ->
    @i18nDate @_attribute(item, attr), 'short'

  _attributeList: (item, attr, delimiter = ', ') ->
    @_attribute(item, attr).join delimiter

  _edit: (e) ->
    @selectedId = eventToItemId(e)
    @fire 'data-table-edit', id: @selectedId

  _delete: (e) ->
    item = e.model.item
    message = I18n.t 'message.confirm_delete',
      model: I18n.t @_to_snake_case "models.#{item.type || @model}.one"
      name: item[@titleAttribute]
    id = eventToItemId(e)
    @$.deleteConfirmation.ask(message).then =>
      @resource.destroy(id).then =>
        @load()
      , ->
    , ->

  _new: ->
    @fire 'data-table-new'

  _fireAction: (e) ->
    action = e.model.action
    itemId = eventToItemId(e)
    if action.routeTo
      route = action.routeTo
      route = route.replace ':id', itemId
    else
      action.fireAction itemId

  _onSearchKeyPress: (e) ->
    if e.keyCode == 13
      @_search()

  _clearSearch: ->
    @searchText = ''
    @search() unless @realtimeSearch

  _searchTextChanged: ->
    @search() if @realtimeSearch

  _search: ->
    @fire 'data-table-search'

  _cellTapped: (e) ->
    model = e.model
    model.column.fire 'cell-tapped', {item: model.item, column: model.column}

  _to_snake_case: (s) ->
    s?.replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase()

  _templateRefId: (name) ->
    "column-#{name}"
