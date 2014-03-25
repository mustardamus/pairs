Socket     = require('../socket')
Encryption = require('../encryption')
Keys       = require('../keys')
Layout     = require('./layout')

class Remote
  constructor: ->
    @socket     = new Socket
    @encryption = new Encryption
    @keys       = new Keys
    @layout     = new Layout

    @socket.io.on 'paired', =>
      @layout.onPaired()

    hash = location.hash

    if hash.length isnt 0
      @hashData = hash.split('#')[1]
      # else hide visual code form
      # show msg to scan qr code

    $('#visual-code').on 'submit', (e) =>
      if @hashData
        key = $('#visual-code-input').val()
        ret = @keys.decryptWithVisualKey(key, @hashData)

        @connect() if ret is true

      e.preventDefault()
      false

    $('#button-dim').click =>
      @sendCommand { command: 'dim', event: 'click', selector: '#button-dim' }

      false

  connect: ->
    @socket.io.emit 'connect',
      pairId    : @keys.pairId
      deviceType: 'remote'

  sendCommand: (data) ->
    command  = @encryption.encryptAes(data.command, @keys.encryptionKey)
    event    = @encryption.encryptAes(data.event, @keys.encryptionKey)
    selector = @encryption.encryptAes(data.selector, @keys.encryptionKey)
    
    @socket.io.emit 'message',
      command      : command
      event        : event
      selector     : selector
      pairId       : @keys.pairId


jQuery ->
  new Remote