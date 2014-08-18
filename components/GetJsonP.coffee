# @runtime noflo-browser

noflo = require 'noflo'

class GetJsonP extends noflo.AsyncComponent
  constructor: ->
    @inPorts =
      url: new noflo.Port 'string'
    @outPorts =
      out: new noflo.Port 'string'
      error: new noflo.Port 'object'

    super 'url'

  doAsync: (url, callback) ->
    # Construct a unique identifier for the callback
    id = 'noflo'+(Math.random()*100).toString().replace /\./g, ''

    # Get the body element
    body = document.querySelector 'body'
    s = document.createElement 'script'
    s.onerror = (e) ->
      delete window[id]
      body.removeChild s
      callback e

    # Register a function with the unique ID
    window[id] = (data) =>
      # Cleanup
      delete window[id]
      body.removeChild s

      if data and data.meta and data.meta.status is 404
        return callback new Error "#{url} not found}"

      @outPorts.out.beginGroup url
      @outPorts.out.send data
      @outPorts.out.endGroup()

      do callback

    # Prepare a script element
    s.type = 'application/javascript'

    if url.indexOf('?') is -1
      url = "#{url}?callback=?"

    s.src = url.replace 'callback=?', "callback=#{id}"

    # Place the script element into DOM
    body.appendChild s

exports.getComponent = -> new GetJsonP
