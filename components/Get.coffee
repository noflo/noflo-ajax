# @runtime noflo-browser

noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'globe'
  c.description = 'HTTP GET a URL'
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

    req = new XMLHttpRequest
    req.onreadystatechange = ->
      return unless req.readyState is 4
      if req.status is 200
        output.sendDone
          out: req.responseText
        return
      output.done new Error "Error loading #{url}"
    req.open 'GET', url, true
    req.send null
