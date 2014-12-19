Polymer 'coyoho-app-drawer',

  menuSelected: (e) ->
    if e.detail.item.hasAttribute 'go'
      @go e
    else if e.detail.item.hasAttribute 'delegate'
      @delegate e

  go: (e) ->
    @router.go e.detail.item.getAttribute('go')

  delegate: (e) ->
    delegate = e.detail.item.getAttribute 'delegate'
    match = delegate.match /^(?:(\w+)\.)?(\w+)(?:\(([^,]+)(?:,([^,]+))?\))?$/
    if match
      [_, target, method, arg1, arg2] = match
      target = if target then @[target] else @
      target[method](eval(arg1), eval(arg2))
