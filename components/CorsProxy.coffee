noflo = require 'noflo'

# @runtime noflo-browser

isExternal = (url) ->
  return false if url.indexOf('data:') is 0
  (location.href.replace("http://", "").replace("https://", "").split("/")[0] isnt url.replace("http://", "").replace("https://", "").split("/")[0])

exports.getComponent = ->
  c = new noflo.Component
  c.description = 'Converts a URL to use a CORS-enabling proxy'
  c.icon = 'arrow-circle-o-right'
  c.service = 'http://crossorigin.me/'
  c.inPorts.add 'in',
    datatype: 'string'
  c.outPorts.add 'out',
    datatype: 'string'
  c.process (input, output) ->
    return unless input.hasData 'in'
    payload = input.getData 'in'
    unless typeof payload is 'string'
      return output.done new Error 'String required'

    out = payload
    if noflo.isBrowser() and isExternal payload
      match_http = /^(https?):\/\//
      path = payload.replace(match_http, '')
      out = c.service + path
    output.sendDone
      out: out
