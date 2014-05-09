io    = require('socket.io')
Stats = require('./stats')

class Server
  constructor: ->
    @io          = io.listen(12222)
    @connections = {}
    @bedtime     = 1000 * 60 * 30
    @stats       = new Stats

    @setupSocketIo()

    @io.sockets.on 'connection', (socket) =>
      socket.on 'connect', (data) => @onConnection(socket, data)
      socket.on 'message', (data) => @onMessage(socket, data)

    setInterval =>
      @cleanConnections()
    , @bedtime

  setupSocketIo: ->
    @io.enable 'browser client minification'
    @io.enable 'browser client etag'
    @io.enable 'browser client gzip'

    @io.set 'log level', 1
    @io.set 'transports', [
      'websocket', 'flashsocket'
      'htmlfile', 'xhr-polling'
      'jsonp-polling'
    ]

  onConnection: (socket, data) ->
    return unless data.pairId

    pairId  = data.pairId
    pairObj = @connections[pairId]

    unless pairObj
      pairObj = @connections[pairId] = { devices: [] }

    # check if already in array
    # instead of array, hash with socket.id as keys!
    pairObj.devices.push
      lastSeen  : Date.now()
      deviceType: data.deviceType
      socket    : socket

    pairObj.lastSeen = Date.now()

    if pairObj.devices.length > 1
      @emitToPairs data.pairId, socket, 'paired'
      socket.emit 'paired', {}
      @stats.incPairs()

    @stats.incVisits()
    socket.emit 'stats', @stats.getStats()
    
    console.log 'new connected device', pairId, data

  onMessage: (socket, data) ->
    console.log 'message from', socket.id, data
    @emitToPairs data.pairId, socket, 'message', data

  emitToPairs: (pairId, socket, msg, data = {}) ->
    pairObj = @connections[pairId]

    return unless pairObj

    delete data.pairId
    pairObj.lastSeen = Date.now()

    for device in pairObj.devices
      if device.socket.id isnt socket.id or 1 is 1 # dont stream to self
        device.socket.emit msg, data
        console.log 'emit message', pairId, msg, data
      else
        device.lastSeen = Date.now()

  cleanConnections: ->
    for pairsId, pairs of @connections
      if Date.now() - pairs.lastSeen > @bedtime
        delete @connections[pairsId]


new Server