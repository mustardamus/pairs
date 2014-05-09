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

    $('#visual-key-recreate').on 'click', =>
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

    # friday is hack day - then party
    $('#slider').on 'cycle-after', (e, opt, slideOutEl, slideInEl) =>
      imgSrc = $(slideInEl).attr('src')
      data = @encryption.encryptAes(imgSrc, @keys.encryptionKey)

      @socket.io.emit 'message', { name: 'update', data: data }

  generateQRCode: ->
    visualKey = @keys.generateVisualKey()
    
    @qrCode.generateCode @keys.pairId, @keys.encryptionKey, visualKey
    @layout.setVisualKey visualKey


jQuery ->
  new Desktop