Polymer 'caretaker-codemirror-input',

  created: ->
    @theme = 'base16-dark'
    @value = ''

  ready: ->
    input = @$.input
    classes = @getAttribute 'class'
    @removeAttribute 'class'
    id = @getAttribute 'id'
    @removeAttribute 'id'
    input.id = id
    input.setAttribute 'class', classes
    codemirror = CodeMirror.fromTextArea input,
      mode: @mode
      theme: @theme
      lineNumbers: true
      matchBrackets: true
    codemirror.getDoc().setValue @value
    codemirror.on 'change', (-> @value = codemirror.getValue()).bind @
    @async -> codemirror.refresh()
