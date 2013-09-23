noflo = require 'noflo'
GetJsonP = require 'noflo-ajax/components/GetJsonP.js'

describe 'GetJsonP component', ->
  c = null
  url = null
  out = null
  beforeEach ->
    c = GetJsonP.getComponent()
    url = noflo.internalSocket.createSocket()
    out = noflo.internalSocket.createSocket()
    c.inPorts.url.attach url
    c.outPorts.out.attach out

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
