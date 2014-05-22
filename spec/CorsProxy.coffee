noflo = require 'noflo'
CorsProxy = require 'noflo-ajax/components/CorsProxy.js'

describe 'CorsProxy component', ->
  c = null
  url = null
  out = null
  beforeEach ->
    c = CorsProxy.getComponent()
    url = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.in.attach url
    c.outPorts.out.attach out

  describe 'when instantiated', ->
    it 'should have an in port', ->
      chai.expect(c.inPorts.in).to.be.an 'object'
    it 'should have an out port', ->
      chai.expect(c.outPorts.out).to.be.an 'object'

  describe 'when sending an external url in', ->
    inputurl = 'http://example.com/mypath.ext'
    it 'should send a group with the input url', (done) ->
      out.on 'begingroup', (data) ->
        chai.expect(data).to.be.a 'string'
        chai.expect(data).to.equal inputurl
        done()
      url.send inputurl
    it 'should send path prefixed with corsproxy', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.a 'string'
        chai.expect(data).to.equal 'http://www.corsproxy.com/'+'example.com/mypath.ext'
        done()
      url.send inputurl

  describe 'when sending a local url in', ->
    inputurl = 'http://localhost:9000/mypath.ext'
    it 'should send a group with the input url', (done) ->
      out.on 'begingroup', (data) ->
        chai.expect(data).to.be.a 'string'
        chai.expect(data).to.equal inputurl
        done()
      url.send inputurl
    it 'should send url unmodified', (done) ->
      out.on 'data', (data) ->
        chai.expect(data).to.be.a 'string'
        chai.expect(data).to.equal inputurl
        done()
      url.send inputurl
