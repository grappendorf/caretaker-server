root = exports ? this

root.CaretakerUtilsBehavior =

  _to_snake_case: (s) ->
    s?.replace(/([a-z])([A-Z])/g, '$1_$2').toLowerCase()

  _equals: (x, y) ->
    x == y
