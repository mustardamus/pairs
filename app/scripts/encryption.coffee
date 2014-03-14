module.exports = class Encryption
  constructor: ->

  randString: (length = 16) ->
    Math.random().toString(36).substr(2, length)

  encryptAes: (data, key) ->
    GibberishAES.enc data, key

  decryptAes: (data, key) ->
    GibberishAES.dec data, key