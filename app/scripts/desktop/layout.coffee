module.exports = class Layout
  constructor: ->
    @winEl = $(window)
    @bannerEl = $('#banner')
    @qrEl = $('#qr-wrapper')
    @navigationEl = $('#navigation-wrapper')

    @qrEl.waypoint (dir) =>
      if dir is 'down'
        @downsizeBanner()
      else
        @upsizeBanner()

    $('#navigation a:first', @navigationEl).hover(
      =>
        @bannerEl.addClass 'shake shake-little shake-constant'
      , =>
        @bannerEl.removeClass 'shake shake-little shake-constant'
    )

    $('#navigation a', @navigationEl).not(':first').smoothScroll()
    $('#navigation a:first', @navigationEl).on 'click', =>
      @upsizeBanner()
      $('html,body').scrollTop(0)
      false

  downsizeBanner: ->
    @bannerEl.animate
      height: 110
    , 'fast'

    $('img', @bannerEl).animate
      top: '-300px'
    , 'fast'

    @navigationEl.animate
      top: '-15px'
    , 'fast', =>
      @navigationEl.addClass 'small'

    @qrEl.fadeOut 100

  upsizeBanner: ->
    @bannerEl.animate
      height: '80%'
    , 'fast'

    $('img', @bannerEl).animate
      top: '-100px'
    , 'fast'

    @navigationEl.animate
      top: '80%'
    , 'fast', =>
      @navigationEl.removeClass 'small'

    @qrEl.fadeIn 100

  laterBoy: ->
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
      $('body').css 'overflow', 'auto'
      $('#loading').fadeOut 800

    $('#haeh').on 'click', ->
      $('#credits').fadeIn 'fast'
      $(@).fadeOut 'fast'

    $('#credits .close').on 'click', ->
      $(@).parent().fadeOut 'fast'
      $('#haeh').fadeIn 'fast'

    $('#right-wrapper').css
      height: $(window).height()
      overflow: 'hidden'

    @statsEl  = $('#stats')
    @visitsEl = $('#stats-visits', @statsEl)
    @pairsEl  = $('#stats-pairings', @statsEl)

  updateStats: (stats) ->
    @visitsEl.text stats.visits
    @pairsEl.text stats.pairs
    @statsEl.fadeIn 'slow'

  onPaired: ->
    $('.logo').addClass 'paired'
    top = $('#phone-wrapper').offset().top - 10
    
    $('#verification-wrapper').animate
      top: "-#{top}px" # these days i like it nasty
    , 'fast'

    $('#phone-wrapper').animate
      top: "-#{top}px" # these days i like it nasty
    , 'fast'

    $('#subscribe-wide').children().fadeOut('slow')

    $('#steps h4 span').addClass 'paired'

  setVisualKey: (visualKey) ->
    $('#visual-key').text visualKey