sendKeyEvent = (element, type, keyCode) ->
	e = document.createEvent 'KeyboardEvent'

	# Chrome hack
	Object.defineProperty e, 'keyCode',
		get: ->
			this.keyCodeVal
	Object.defineProperty e, 'which',
		get: ->
			this.keyCodeVal

	if e.initKeyboardEvent?
		e.initKeyboardEvent type, true, true, document.defaultView, false, false, false, false, keyCode, keyCode
	else
		e.initKeyEvent type, true, true, document.defaultView, false, false, false, false, k, 0

	e.keyCodeVal = keyCode;
	element.dispatchEvent e
