async = (self, f) ->
	f = f.bind(self) if f?
	f = self unless f
	setTimeout ->
		f()
	, 0
