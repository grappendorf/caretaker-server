eventToItemId = (e) ->
  $(e.target).parents('tr')[0].attributes['data-item-id'].value


Polymer 'caretaker-data-table',

  created: ->
    @data = []
    @columns = []
    @actions = []
    @selectedId = null
    @realtimeSearch = false
    @titleAttribute = 'name'

  ready: ->
    column_nodes = @querySelectorAll('caretaker-data-column')
    @columns = (@initColumn(column) for column in column_nodes)
    action_nodes = @querySelectorAll('caretaker-data-action')
    @actions = (action for action in action_nodes)

  initColumn: (column) ->
    column.heading = if column.heading? then column.heading else @$.i18n.t "attributes.#{@model}.#{column.name}"
    column.thClass = ("width-#{width}" for width in column.width.split(' ')).join ' '
    column.thClass += " #{column.headerAlign}" if column.headerAlign
    column.tdClass = column.align
    if column.type == 'template'
      @shadowRoot.appendChild column.template
    column

  load: ->
    self = @
    @resource.index (result) ->
      self.data = result

  attribute: (item, attr) ->
    ([item].concat(attr.split('.')).reduce (i, p) -> i[p]) || ''

  attributeCheckIcon: (item, attr) ->
    if @attribute(item, attr) then 'check-square-o' else 'square-o'

  attributeList: (item, attr, delimiter = ', ') ->
    @attribute(item, attr).join delimiter

  attributeCustom: (item, column) ->
    console.log @

  edit: (e) ->
    @selectedId = eventToItemId(e)
    @fire 'data-table-edit', id: @selectedId

  delete: (e) ->
    item = e.target.templateInstance.model.item
    message = I18n.t 'message.confirm_delete',
      model: I18n.t PolymerExpressions.prototype.to_snake_case "models.#{item.type || @model}.one"
      name: item[@titleAttribute]
    self = @
    id = eventToItemId(e)
    @$.deleteConfirmation.ask(message).then ->
      self.resource.delete id
      self.load()
    , ->

  new: ->
    @fire 'data-table-new'

  fireAction: (e) ->
    action = e.target.templateInstance.model.action
    itemId = e.target.getAttribute('data-item-id')
    if action.routeTo
      route = action.routeTo
      route = route.replace ':id', itemId
    else
      action.fireAction itemId

  onSearchKeyPress: (e) ->
    if e.keyCode == 13
      @search()

  clearSearch: ->
    @searchText = ''
    @search() unless @realtimeSearch

  searchTextChanged: ->
    @search() if @realtimeSearch

  search: ->
    @fire 'data-table-search'

  cellTapped: (e) ->
    model = e.target.templateInstance.model
    if model.column.getAttribute 'on-cell-tapped'
      model.column.fire 'cell-tapped', {item: model.item, column: model.column}
