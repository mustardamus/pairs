module.exports = class Remote
  constructor: ->

  onConnect: (server, socket, data, pairs) ->
    server.storeSocket 'remote', data.connectionKey, socket

    if pairs.desktopSocket # desktop is already registered
      socket.emit 'remote:paired', data
      pairs.desktopSocket.emit 'desktop:paired', data

  onCommand: (server, socket, data, pairs) ->
    if pairs.desktopSocket
      pairs.desktopSocket.emit 'desktop:command', data
    
    console.log 'execute remote command', data