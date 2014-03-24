module.exports = class Socket
  socketUrl: 'http://192.168.0.13:12222'

  constructor: ->
    if location.hostname is 'pairs.io'
      @socketUrl = 'http://pairs.io:12222'

    @io = io.connect(@socketUrl)