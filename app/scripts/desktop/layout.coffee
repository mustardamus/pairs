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
    , { offset: -100 }

    tryOutEl = $('#navigation a:first', @navigationEl)
    navAs = $('#navigation a', @navigationEl)
    
    navAs.not(':first').smoothScroll({speed:200})

    markCurrentWhoopy = (el) ->
      id = el.attr('id')

      navAs.removeClass 'current'
      navAs.parent().find("a[href='##{id}']").addClass 'current'

    tryOutEl
      .hover(
        =>
          @bannerEl.addClass 'shake shake-little shake-constant'
        , =>
          @bannerEl.removeClass 'shake shake-little shake-constant'
      )
      .on 'click', ->
        el = $(@)

        $('html,body').animate
          scrollTop: 0
        , 'fast', ->
          navAs.removeClass 'current'
          el.addClass 'current'

        false

    sectionEls = $('#content .section')

    sectionEls.waypoint (dir) ->
      markCurrentWhoopy($(@)) if dir is 'down'
    , { offset: 50 }

    sectionEls.waypoint (dir) ->
      markCurrentWhoopy($(@)) if dir is 'up'
    , { offset: '-80%' }

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