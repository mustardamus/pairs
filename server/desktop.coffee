module.exports = class Desktop
  constructor: ->

  onConnect: (server, socket, data, pairs) ->
    server.storeSocket 'desktop', data.connectionKey, socket