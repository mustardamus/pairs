Encryption = require('./encryption')

module.exports = class Keys
  constructor: ->
    @encryption = new Encryption

    @initKey('pairId')
    @initKey('encryptionKey')
    @visualKey = @generateVisualKey()

  initKey: (keyName) ->
    key = localStorage.getItem(keyName)

    unless key
      key = @encryption.randString()
    
    @setKey keyName, key

  setKey: (keyName, value) ->
    localStorage.setItem keyName, value
    @[keyName] = value

  generateVisualKey: ->
    @visualKey = @encryption.randString(5)
    @visualKey

  decryptWithVisualKey: (key, base64) ->
    valid = false

    try
      encData = Base64.decode(base64)
      decData = @encryption.decryptAes(encData, key)
      json    = JSON.parse(decData)
      
      @setKey 'pairId', json.pId
      @setKey 'encryptionKey', json.eKey

      @visualKey = key
      valid      = true
    catch e
      
    valid

  clear: ->
    localStorage.clear()