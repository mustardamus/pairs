module.exports = class Layout
  constructor: (socket, keys) ->
    @socket = socket
    @keys = keys

    @winEl = $(window)
    @bannerEl = $('#banner')
    @qrEl = $('#top-wrapper')
    @navigationEl = $('#navigation-wrapper')

    tryOutEl = $('#navigation a:first', @navigationEl)
    navAs = $('#navigation a', @navigationEl)

    @qrEl.waypoint (dir) =>
      if dir is 'down'
        @downsizeBanner()
      else
        @upsizeBanner()
        navAs.removeClass 'current'
        tryOutEl.addClass 'current'
    , { offset: -100 }
    
    navAs.not(':first').smoothScroll({speed:200})

    markCurrentWhoopy = (el) ->
      id = el.attr('id')

      navAs.removeClass 'current'
      navAs.parent().find("a[href='##{id}']").addClass 'current'

    $('.try-it-out')
      .hover(
        =>
          @bannerEl.addClass 'shake shake-little shake-constant'
        , =>
          @bannerEl.removeClass 'shake shake-little shake-constant'
      )
      .on 'click', ->
        $('html,body').animate
          scrollTop: 0
        , 'fast', ->
          navAs.removeClass 'current'
          tryOutEl.addClass 'current'

        false

    sectionEls = $('#content .section')

    sectionEls.waypoint (dir) ->
      markCurrentWhoopy($(@)) if dir is 'down'
    , { offset: 50 }

    sectionEls.waypoint (dir) ->
      markCurrentWhoopy($(@)) if dir is 'up'
    , { offset: '-80%' }

    sliderEl = $('#slider')

    sliderEl.cycle
      timeout: 1000
      prev: '#slider-prev'
      next: '#slider-next'

    sliderEl.on 'cycle-after', (e, opt, slideOutEl, slideInEl) =>
      imgSrc = $(slideInEl).attr('src')
      $('#current-image img').attr('src', imgSrc)

    sliderEl.cycle('pause')

    self = @

    $('#slider-play').on 'click', ->
      el = $(@)

      if el.hasClass 'playing'
        sliderEl.cycle('pause')
        el.removeClass 'playing'
        el.html '<i class="fa fa-play"></i>'
        self.socket.io.emit 'message', { pairId: self.keys.pairId, name: 'pause', data: {}}
      else
        sliderEl.cycle('resume')
        el.addClass 'playing'
        el.html '<i class="fa fa-pause"></i>'
        self.socket.io.emit 'message', { pairId: self.keys.pairId, name: 'play', data: {}}

      false

    @statsEl  = $('#stats')
    @visitsEl = $('#stats-visits', @statsEl)
    @pairsEl  = $('#stats-pairings', @statsEl)

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

  updateStats: (stats) ->
    @visitsEl.text stats.visits
    @pairsEl.text stats.pairs
    @statsEl.fadeIn 'slow'

  onPaired: ->
    scrollEl = $('html,body')

    scrollEl.animate
      scrollTop: 200
    , 'fast', ->
      $('body').addClass 'paired'

      setTimeout ->
        scrollEl.animate { scrollTop: 0 }, 'fast'
      , 100
    

  setVisualKey: (visualKey) ->
    $('#visual-key').text visualKey