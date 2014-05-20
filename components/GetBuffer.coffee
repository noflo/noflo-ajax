# @runtime noflo-nodejs
# @name GetBuffer

noflo = require 'noflo'
http = require 'http'

class GetBuffer extends noflo.AsyncComponent
  constructor: ->
    @inPorts =
      url: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'object'
      error: new noflo.Port 'object'
    super 'url'

  doAsync: (url, callback) ->
    req = http.get url, (res) =>
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
      res.on 'end', () =>
        @outPorts.out.beginGroup url
        slice = data.slice 0, dataLength
        @outPorts.out.send slice
        @outPorts.out.endGroup()
        callback()
      req.on 'error', ->
        callback new Error "Error loading #{url}"

exports.getComponent = -> new GetBuffer
