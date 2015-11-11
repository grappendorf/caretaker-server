Polymer

  is: 'caretaker-select'

  properties:
    items: {type: Array, value: (-> []), observer: '_itemsChanged'}
    placeholder: {type: String}
    selectedId: {type: String, notify: true}

  deselect: ->
    if @placeholder
      @$.select.value = @placeholder if @$.select.value != @placeholder
    else
      @$.select.value = null

  _itemsChanged: ->
    unless @selectedId?
      @selectedId = if @placeholder? then null else @items?[0]?.id

  _onChange: (e) ->
    index = @$.select.selectedIndex
    index = index - 1 if @placeholder?
    @selectedId = if index >= 0 then @items[index].id else null

  _isItemSelected: (itemId, selectedId) ->
    itemId == selectedId
