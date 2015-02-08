fixture = (name) ->

  beforeEach (done) ->
    @container = document.createElement "div"
    @container.innerHTML = __html__["karma/#{name}"]
    document.body.appendChild @container
    async -> done()

  afterEach ->
    document.body.removeChild @container
