noflo = require 'noflo'
baseDir = 'noflo-ajax'

describe 'Get component', ->
  c = null
  url = null
  out = null
  before (done) ->
    @timeout 4000
    loader = new noflo.ComponentLoader baseDir
    loader.load 'ajax/Get', (err, instance) ->
      return done err if err
      c = instance
      url = noflo.internalSocket.createSocket()
      c.inPorts.url.attach url
      done()
  beforeEach ->
    out = noflo.internalSocket.createSocket()
    c.outPorts.out.attach out
  afterEach ->
    c.outPorts.out.detach out
    out = null

  describe 'when instantiated', ->
    it 'should have an url port', ->
      chai.expect(c.inPorts.url).to.be.an 'object'
    it 'should have an output port', ->
      chai.expect(c.outPorts.out).to.be.an 'object'
    it 'should have an error port', ->
      chai.expect(c.outPorts.error).to.be.an 'object'

  describe 'fetching an existing URL', ->
    it 'should return contents as string', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.a 'string'
        done()
      url.send '../package.json'

  describe 'fetching an failing URL', ->
    it 'should return an error', (done) ->
      err = noflo.internalSocket.createSocket()
      c.outPorts.error.attach err
      err.on 'data', (data) ->
        chai.expect(data).to.be.an 'error'
        done()
      url.send 'http://noflojs.org/foo'
