Socket     = require('./socket')
Encryption = require('./encryption')

module.exports = class Remote
  constructor: ->
    @socket        = new Socket
    @encryption    = new Encryption

    @socket.io.on 'remote:paired', => @onPaired()

    @encHashData = location.hash.split('#').join('')
    #console.log @encHashData.length # can not be null
    # show error msg

    $('#visual-code').on 'submit', (e) =>
      key = $('#visual-code-input').val()
      e.preventDefault()
      false

      @encodeAndConnect key

    $('#visual-code-input').focus()
    # prompt() # shortcut und vom browser gestylt!

    self = @
    $('#button-dim').click ->
      spanEl = $(@).children('span')

      if spanEl.text() is 'Off'
        spanEl.text 'On'
        spanEl.addClass 'dim-on'
        spanEl.removeClass 'dim-off'
      else
        spanEl.text 'Off'
        spanEl.addClass 'dim-off'
        spanEl.removeClass 'dim-on'

      self.sendCommand { command: 'dim', event: 'click', selector: '#button-dim' }

      false

    #@onPaired()

  connectToServer: ->
    @socket.io.emit 'remote:connect',
      connectionKey: @connectionKey

  sendCommand: (data) ->
    command  = @encryption.encryptAes(data.command, @encryptionKey)
    event    = @encryption.encryptAes(data.event, @encryptionKey)
    selector = @encryption.encryptAes(data.selector, @encryptionKey)
    
    @socket.io.emit 'remote:command',
      command      : command
      event        : event
      selector     : selector
      connectionKey: @connectionKey

  encodeAndConnect: (key) ->
    good = false

    try
      base64 = Base64.decode(@encHashData)
      decData = @encryption.decryptAes(base64, key)
      obj = JSON.parse(decData)
      
      @connectionKey = obj.ck
      @encryptionKey = obj.ek
      good = true
    catch e
      null isnt null
    
    @connectToServer() if good

  onPaired: ->
    $('.logo').addClass 'paired'
    $('body').addClass 'isPaired'