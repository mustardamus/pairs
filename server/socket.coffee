Desktop = require('./desktop')
Remote  = require('./remote')

class SocketServer
  constructor: ->
    @io      = require('socket.io').listen(12222)
    @desktop = new Desktop
    @remote  = new Remote

    @connections = {}

    routes =
      'desktop:connect': @desktop.onConnect
      'desktop:command': @desktop.onCommand
      'remote:connect' : @remote.onConnect
      'remote:command' : @remote.onCommand

    @io.enable('browser client minification')  # send minified client
    @io.enable('browser client etag')          # apply etag caching logic based on version number
    @io.enable('browser client gzip')          # gzip the file
    @io.set('log level', 1)                    # reduce logging

    @io.set('transports', [
        'websocket'
      , 'flashsocket'
      , 'htmlfile'
      , 'xhr-polling'
      , 'jsonp-polling'
    ])

    @io.sockets.on 'connection', (socket) =>
      for routeUrl, routeFunc of routes
        do (routeUrl, routeFunc) =>
          socket.on routeUrl, (data) =>
            routeFunc(@, socket, data, @getPairs(data.connectionKey))

    setInterval =>
      @cleanConnections()
    , 1000 * 60 * 30

  storeSocket: (socketType, connectionKey, socket) ->
    keyObj = @connections[connectionKey]

    unless keyObj
      @connections[connectionKey] = keyObj = {}

    keyObj["#{socketType}Socket"] = socket
    keyObj.lastSeen = Date.now()

    console.log "new #{socketType} connection:", connectionKey

  getPairs: (connectCode) ->
    for code, data of @connections
      if code is connectCode
        return data

    false

  cleanConnections: ->
    for connectionKey, pairs of @connections
      if Date.now() - pairs.lastSeen > 1000 * 60 * 30
        delete @connections[connectionKey]

new SocketServer