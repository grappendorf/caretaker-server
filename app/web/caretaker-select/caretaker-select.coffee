Polymer 'caretaker-select',

  created: ->
    @items = []

  itemsChanged: ->
    unless @selectedId?
      @selectedId = if @placeholder? then null else @items?[0]?.id

  onChange: (e) ->
    index = @$.select.selectedIndex
    index = index - 1 if @placeholder?
    @selectedId = if index >= 0 then @items[index].id else null
