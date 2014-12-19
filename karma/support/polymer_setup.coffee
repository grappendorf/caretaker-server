script = document.createElement 'script'
script.src = '/base/public/platform/platform.js'
document.getElementsByTagName('head')[0].appendChild script

imports = [
	'coyoho-about/coyoho-about.html'
]

for i in imports
	link = document.createElement 'link'
	link.rel = 'import'
	link.href = "/base/public/#{i}"
	document.getElementsByTagName("head")[0].appendChild link


POLYMER_READY = false
beforeEach (done) ->
	window.addEventListener 'polymer-ready', ->
		POLYMER_READY = true
		done()
	if POLYMER_READY
		done()
