noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.service = 'http://www.corsproxy.com/'
  
  c.inPorts.add 'in', (event, payload) ->
    if event is 'disconnect'
      c.outPorts.out.disconnect()
    return unless event is 'data'
    match_http = /^(https?):\/\//
    path = payload.replace(match_http, '')
    url = c.service + path
    c.outPorts.out.send url
  c.outPorts.add 'out'
  c
