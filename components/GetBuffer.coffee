# @runtime noflo-nodejs
# @name GetBuffer

noflo = require 'noflo'
http = require 'http'
https = require 'https'
urlParser = require 'url'

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'globe'
  c.description = 'HTTP GET a URL to a Buffer'
  c.inPorts.add 'url',
    datatype: 'string'
  c.outPorts.add 'out',
    datatype: 'string'
  c.outPorts.add 'error',
    datatype: 'object'
  c.forwardBrackets =
    url: ['out', 'error']
  c.process (input, output) ->
    return unless input.hasData 'url'
    url = input.getData 'url'
    {protocol} = urlParser.parse url
    prot = http
    prot = https if protocol is 'https:'
    req = prot.get url, (res) ->
      data = new Buffer 32768
      dataLength = 0
      res.on 'data', (chunk) ->
        newLength = dataLength+chunk.length
        if newLength >= data.length
          newData = new Buffer newLength*2
          data.copy newData, 0, 0, dataLength
          data = newData
        chunk.copy data, dataLength
        dataLength = newLength
      res.on 'end', ->
        slice = data.slice 0, dataLength
        output.sendDone
          out: slice
      req.on 'error', ->
        output.done new Error "Error loading #{url}"
