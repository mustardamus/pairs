module.exports = class Socket
  socketUrl: '192.168.2.105:12222'

  constructor: ->
    if location.hostname is 'pairs.akrasia.me'
      @socketUrl = 'http://pairs.akrasia.me:12222'

    @io = io.connect(@socketUrl)
