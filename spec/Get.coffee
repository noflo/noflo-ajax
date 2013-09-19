noflo = require 'noflo'
Get = require 'noflo-ajax/components/Get.js'

describe 'Get component', ->
  c = null
  url = null
  out = null
  beforeEach ->
    c = Get.getComponent()
    url = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.url.attach url
    c.outPorts.out.attach out

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
        chai.expect(data).to.be.an 'object'
        done()
      url.send 'http://noflojs.org/foo'
