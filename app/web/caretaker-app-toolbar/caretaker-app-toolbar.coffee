Polymer 'caretaker-app-toolbar',

  ready: ->
    @app = document.querySelector('caretaker-app')

  delegate: (e) ->
    if e.toElement
      delegate = e.toElement.getAttribute('delegate-to')
    else
      delegate = e.target.getAttribute('delegate-to')
    match = delegate.match /^(?:(\w+)\.)?(\w+)(?:\(([^,]+)(?:,([^,]+))?\))?$/
    if match
      [_, target, method, arg1, arg2] = match
      target = if target then @[target] else @
      target[method](eval(arg1), eval(arg2))

  route: (e) ->
    @app.$.router.go e.target.getAttribute('route-to')
