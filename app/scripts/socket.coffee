module.exports = class Socket
  socketUrl: '192.168.2.105:12222'

  constructor: ->
    if location.hostname is 'pairs.io'
      @socketUrl = 'http://pairs.io:12222'

    @io = io.connect(@socketUrl)
