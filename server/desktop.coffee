fs = require('fs')
path = require('path')

module.exports = class Desktop
  constructor: ->

  onConnect: (server, socket, data, pairs) ->
    server.storeSocket 'desktop', data.connectionKey, socket

    rootDir = path.join(path.dirname(fs.realpathSync(__filename)), '..')
    filePath = "#{rootDir}/statistics/visits.txt"
    count = fs.readFileSync(filePath, 'utf8')
    count = +count + 1

    fs.writeFileSync filePath, count
    console.log 'new visit: ', count

    pairings = fs.readFileSync("#{rootDir}/statistics/pairings.txt")

    socket.emit 'desktop:stats', { visits: count, pairings: +pairings }