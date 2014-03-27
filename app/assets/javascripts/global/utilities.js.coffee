String.prototype.toDash = ->
	this.replace(/(.)([A-Z])/g, '$1-$2').toLowerCase()
