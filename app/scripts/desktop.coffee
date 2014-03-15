module.exports = class Desktop
  constructor: ->
    Socket     = require('./socket')
    Encryption = require('./encryption')

    @socket     = new Socket
    @encryption = new Encryption

    @rootUrl       = 'http://192.168.0.11:9000'

    if location.hostname is 'pairs.io'
      @rootUrl = 'http://pairs.io'

    @connectionKey = @initKey('connectionCode')
    @encryptionKey = @initKey('encryptionKey')
    @visualKey     = ''

    @qrCode = new QRCode document.getElementById("qr-code"),
      text  : 'pairs.io'
      width : 300
      height: 300

    $.supersized
      slides: [ { image : '../images/remotes_bg_min.png' }]

    $('#visual-code a').on 'click', =>
      @generateVisualKey()
      @generateQrCode()
      false

    @socket.io.on 'desktop:paired', => @onPaired()

    @socket.io.on 'desktop:command', (data) =>
      selector = @encryption.decryptAes(data.selector, @encryptionKey)
      event = @encryption.decryptAes(data.event, @encryptionKey)
      
      $(selector).trigger event

    $('#phone-wrapper').css 'margin-top', $(window).height()

    overlayEl = $('#overlay')

    $('#button-dim').click ->
      spanEl = $(@).children('span')

      if overlayEl.css('display') is 'none'
        overlayEl.fadeIn 'slow'
        spanEl.text 'On'
        spanEl.addClass 'dim-on'
        spanEl.removeClass 'dim-off'
      else
        overlayEl.fadeOut 'slow'
        spanEl.text 'Off'
        spanEl.addClass 'dim-off'
        spanEl.removeClass 'dim-on'
      false

    $('#steps li').on 'click', ->
      liEl = $(@)

      $('#steps .open').removeClass 'open'
      liEl.addClass 'open'

    $('<img src="images/remotes_bg_min.png">').on 'load', ->
      overlayEl.fadeOut 1200

    $('#haeh').on 'click', ->
      $('#credits').fadeIn 'fast'
      $(@).fadeOut 'fast'

    $('#credits .close').on 'click', ->
      $(@).parent().fadeOut 'fast'
      $('#haeh').fadeIn 'fast'

    $('#right-wrapper').css
      height: $(window).height()
      overflow: 'hidden'

    @generateVisualKey()
    @generateQrCode()
    @connectToServer()

    #@onPaired()

  initKey: (keyName) ->
    key = localStorage.getItem(keyName)

    unless key
      key = @encryption.randString()
      localStorage.setItem keyName, key

    key

  connectToServer: ->
    @socket.io.emit 'desktop:connect', 
      connectionKey: @connectionKey

  generateVisualKey: ->
    @visualKey = @encryption.randString(5)
    $('#visual-code span').text @visualKey

  generateQrCode: ->
    json = JSON.stringify({ ck: @connectionKey, ek: @encryptionKey })
    enc  = @encryption.encryptAes(json, @visualKey)
    data = "#{@rootUrl}/remote.html##{enc}"
    
    @qrCode.clear()
    @qrCode.makeCode data
    $('#qr-code').attr 'title', ''

  onPaired: ->
    $('.logo').addClass 'paired'
    top = $('#phone-wrapper').offset().top - 10
    
    $('#verification-wrapper').animate
      top: "-#{top}px" # these days i like it nasty
    , 'fast'

    $('#phone-wrapper').animate
      top: "-#{top}px" # these days i like it nasty
    , 'fast'

    $('#subscribe-wide').fadeOut('slow')

    $('#steps h4 span').addClass 'paired'