initialized = false
defaultLocale = 'en'

i18n = (key, format = null) ->
  if format && typeof(format) == 'string'
    key = format.replace('_', key)
  try
    if format && typeof(format) == 'object'
      format.defaultValue = key
      I18n.t key, format
    else
      I18n.t key, {defaultValue: key}
  catch error
    key

PolymerExpressions.prototype.i18n = (key, format = null) ->
  i18n key, format

PolymerExpressions.prototype.i18n_date = (date, format) ->
  if date then I18n.l "date.formats.#{format}", date else ''

PolymerExpressions.prototype.i18n_time = (date, format) ->
  if date then I18n.l "time.formats.#{format}", date else ''

PolymerExpressions.prototype.i18n_datetime = (date, format) ->
  if date then I18n.l "datetime.formats.#{format}", date else ''


Polymer 'coyoho-i18n',

  defaultLocale: null

  locale: null

  ready: ->
    if @defaultLocale
      I18n.defaultLocale = @defaultLocale
      defaultLocale = @defaultLocale
    else
      @defaultLocale = defaultLocale

    if @locale
      I18n.locale = @locale
      locale = @locale
    else
      @locale = locale

  t: (key) -> i18n key
