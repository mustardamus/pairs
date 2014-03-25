Socket     = require('../socket')
Encryption = require('../encryption')
PQRCode    = require('./qrcode')
Layout     = require('./layout')
Keys       = require('../keys')

class Desktop
  constructor: ->
    @socket     = new Socket
    @encryption = new Encryption
    @qrCode     = new PQRCode
    @layout     = new Layout
    @keys       = new Keys

    $('#visual-code a').on 'click', =>
      @generateQRCode()
      false

    @generateQRCode()

    @socket.io.on 'paired', =>
      @layout.onPaired()

    @socket.io.on 'stats', (stats) =>
      @layout.updateStats(stats)
      
    @socket.io.emit 'connect', 
      pairId    : @keys.pairId
      deviceType: 'desktop'

    @socket.io.on 'message', (data) =>
      selector = @encryption.decryptAes(data.selector, @keys.encryptionKey)
      event = @encryption.decryptAes(data.event, @keys.encryptionKey)
      
      $(selector).trigger event

  generateQRCode: ->
    visualKey = @keys.generateVisualKey()
    
    @qrCode.generateCode @keys.pairId, @keys.encryptionKey, visualKey
    @layout.setVisualKey visualKey


jQuery ->
  new Desktop