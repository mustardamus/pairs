module.exports = class Socket
  socketUrl: 'http://192.168.0.11:12222'

  constructor: ->
    @io = io.connect(@socketUrl)