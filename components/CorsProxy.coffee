noflo = require 'noflo'

isExternal = (url) ->
  (location.href.replace("http://", "").replace("https://", "").split("/")[0] isnt url.replace("http://", "").replace("https://", "").split("/")[0])

exports.getComponent = ->
  c = new noflo.Component
  c.service = 'http://www.corsproxy.com/'
  
  c.inPorts.add 'in', (event, payload) ->
    if event is 'disconnect'
      c.outPorts.out.disconnect()
    return unless event is 'data'
    if noflo.isBrowser()
      unless isExternal payload
        c.outPorts.out.send payload
        return
    match_http = /^(https?):\/\//
    path = payload.replace(match_http, '')
    url = c.service + path
    c.outPorts.out.send url
  c.outPorts.add 'out'
  c
