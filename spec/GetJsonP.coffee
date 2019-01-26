describe 'GetJsonP component', ->
  c = null
  url = null
  out = null
  err = null
  before (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'ajax/GetJsonP', (err, instance) ->
      return done err if err
      c = instance
      url = noflo.internalSocket.createSocket()
      c.inPorts.url.attach url
      done()
  beforeEach ->
    out = noflo.internalSocket.createSocket()
    c.outPorts.out.attach out
    err = noflo.internalSocket.createSocket()
    c.outPorts.error.attach err
  afterEach ->
    c.outPorts.out.detach out
    out = null
    c.outPorts.error.detach err
    err = null

  describe 'when instantiated', ->
    it 'should have an url port', ->
      chai.expect(c.inPorts.url).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(c.outPorts.out).to.be.an 'object'

  describe 'fetching a Gist', ->
    gistUrl = 'https://api.github.com/gists/6608098?callback=?'
    it 'should be able to emit the contents', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.a 'object'
        chai.expect(data.data.description).to.be.a 'string'
        done()
      url.send gistUrl
    it 'should have removed the temporary function', ->
      found = false
      for key, value of window
        if key.substr(0, 5) is 'noflo' and typeof value is 'function'
          found = true
      chai.expect(found).to.equal false
    it 'should have removed the script tag', ->
      found = false
      scripts = document.querySelectorAll('script[src]')
      for script in scripts
        if script.src.indexOf('api.github.com') isnt -1
          found = true
      chai.expect(found).to.equal false

  describe 'fetching a Gist without defined callback', ->
    gistUrl = 'https://api.github.com/gists/6608098'
    it 'should be able to emit the contents', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.a 'object'
        chai.expect(data.data.description).to.be.a 'string'
        done()
      url.send gistUrl
    it 'should have removed the temporary function', ->
      found = false
      for key, value of window
        if key.substr(0, 5) is 'noflo' and typeof value is 'function'
          found = true
      chai.expect(found).to.equal false
    it 'should have removed the script tag', ->
      found = false
      scripts = document.querySelectorAll('script[src]')
      for script in scripts
        if script.src.indexOf('api.github.com') isnt -1
          found = true
      chai.expect(found).to.equal false

  describe 'fetching a non-existing Gist', ->
    gistUrl = 'https://api.github.com/gists/does_not_exist'
    it 'should send to the error port', (done) ->
      err.on 'data', (data) ->
        chai.expect(data).to.be.an 'error'
        done()
      url.send gistUrl
    it 'should have removed the temporary function', ->
      found = false
      for key, value of window
        if key.substr(0, 5) is 'noflo' and typeof value is 'function'
          found = true
      chai.expect(found).to.equal false
    it 'should have removed the script tag', ->
      found = false
      scripts = document.querySelectorAll('script[src]')
      for script in scripts
        if script.src.indexOf('api.github.com') isnt -1
          found = true
      chai.expect(found).to.equal false
  describe 'fetching a non-existing document', ->
    gistUrl = 'http://localhost:9000/foo/bar/baz'
    it 'should send to the error port', (done) ->
      err.on 'data', (data) ->
        chai.expect(typeof data).to.equal 'object'
        done()
      url.send gistUrl
    it 'should have removed the temporary function', ->
      found = false
      for key, value of window
        if key.substr(0, 5) is 'noflo' and typeof value is 'function'
          found = true
      chai.expect(found).to.equal false
    it 'should have removed the script tag', ->
      found = false
      scripts = document.querySelectorAll('script[src]')
      for script in scripts
        if script.src.indexOf('api.github.com') isnt -1
          found = true
      chai.expect(found).to.equal false
