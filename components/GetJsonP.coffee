# @runtime noflo-browser

noflo = require 'noflo'

exports.getComponent = ->
  c = new noflo.Component
  c.icon = 'globe'
  c.description = 'Get contents via JSONP from a URL'
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

    # Construct a unique identifier for the callback
    id = 'noflo'+(Math.random()*100).toString().replace /\./g, ''

    # Get the body element
    body = document.querySelector 'body'
    s = document.createElement 'script'
    s.onerror = (e) ->
      delete window[id]
      body.removeChild s
      output.done e

    # Register a function with the unique ID
    window[id] = (data) ->
      # Cleanup
      delete window[id]
      body.removeChild s

      if data and data.meta and data.meta.status is 404
        return output.done new Error "#{url} not found}"

      output.sendDone
        out: data

    # Prepare a script element
    s.type = 'application/javascript'

    if url.indexOf('?') is -1
      url = "#{url}?callback=?"

    s.src = url.replace 'callback=?', "callback=#{id}"

    # Place the script element into DOM
    body.appendChild s
