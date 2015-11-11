Polymer

  is: 'caretaker-codemirror-input'

  properties:
    value: {type: String, notify: true}
    mode: {type: String}
    theme: {type: String, value: 'base16-dark'}
    rows: {type: String}

  attached: ->
    input = @$.input
    classes = @getAttribute 'class'
    Polymer.dom(@).removeAttribute 'class'
    id = @getAttribute 'id'
    Polymer.dom(@).removeAttribute 'id'
    input.id = id
    input.setAttribute 'class', classes
    codemirror = CodeMirror.fromTextArea input,
      mode: @mode
      theme: @theme
      lineNumbers: true
      matchBrackets: true
    codemirror.getDoc().setValue(@value || '')
    codemirror.on 'change', =>
      @value = codemirror.getValue()
    @async -> codemirror.refresh()
