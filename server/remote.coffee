fs = require('fs')
path = require('path')

module.exports = class Remote
  constructor: ->

  onConnect: (server, socket, data, pairs) ->
    server.storeSocket 'remote', data.connectionKey, socket

    if pairs.desktopSocket # desktop is already registered
      socket.emit 'remote:paired', data
      pairs.desktopSocket.emit 'desktop:paired', data

      rootDir = path.join(path.dirname(fs.realpathSync(__filename)), '..')
      filePath = "#{rootDir}/statistics/pairings.txt"
      count = fs.readFileSync(filePath, 'utf8')
      count = +count + 1

      fs.writeFileSync filePath, count
      console.log 'new pairing: ', count

  onCommand: (server, socket, data, pairs) ->
    if pairs.desktopSocket
      pairs.desktopSocket.emit 'desktop:command', data
    
    console.log 'execute remote command', data