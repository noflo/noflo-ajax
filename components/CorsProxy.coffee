noflo = require 'noflo'

# @runtime noflo-browser

isExternal = (url) ->
  return false if url.indexOf('data:') is 0
  (location.href.replace("http://", "").replace("https://", "").split("/")[0] isnt url.replace("http://", "").replace("https://", "").split("/")[0])

exports.getComponent = ->
  c = new noflo.Component
  c.service = 'http://www.corsproxy.com/'
  
  c.inPorts.add 'in', (event, payload) ->
    if event is 'begingroup'
      c.outPorts.out.beginGroup payload
    if event is 'endgroup'
      c.outPorts.out.endGroup()
    if event is 'disconnect'
      c.outPorts.out.disconnect()
    return unless event is 'data'
    out = payload
    if noflo.isBrowser() and isExternal payload
      match_http = /^(https?):\/\//
      path = payload.replace(match_http, '')
      out = c.service + path
    c.outPorts.out.beginGroup payload
    c.outPorts.out.send out
    c.outPorts.out.endGroup()
  c.outPorts.add 'out'
  c
