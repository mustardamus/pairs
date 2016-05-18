Encryption = require('../encryption')

module.exports = class PQRCode
  constructor: ->
    @encryption = new Encryption

    @qrEl   = $('#qr-code')
    @qrCode = new QRCode @qrEl.get(0),
      text  : 'pairs.akrasia.me'
      width : 300
      height: 300

    @rootUrl = 'http://192.168.2.105:9000'

    if location.hostname is 'pairs.akrasia.me'
      @rootUrl = 'http://pairs.akrasia.me'

  generateCode: (pairId, encryptionKey, visualKey) ->
    json      = JSON.stringify({ pId: pairId, eKey: encryptionKey })
    encrypted = @encryption.encryptAes(json, visualKey)
    data      = Base64.encode(encrypted)

    @qrCode.clear()
    @qrCode.makeCode "#{@rootUrl}/remote.html##{data}"
    @qrEl.attr 'title', ''
