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

    @io.sockets.on 'connection', (socket) =>
      for routeUrl, routeFunc of routes
        do (routeUrl, routeFunc) =>
          socket.on routeUrl, (data) =>
            routeFunc(@, socket, data, @getPairs(data.connectionKey))

  storeSocket: (socketType, connectionKey, socket) ->
    keyObj = @connections[connectionKey]

    unless keyObj
      @connections[connectionKey] = keyObj = {}

    keyObj["#{socketType}Socket"] = socket

    console.log "new #{socketType} connection:", connectionKey

  getPairs: (connectCode) ->
    for code, data of @connections
      if code is connectCode
        return data

    false

new SocketServer