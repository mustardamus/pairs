module.exports = class Layout
  constructor: ->
    winEl = $(window)
    imgEl = $('#playing img')

    winEl.on 'resize', ->
      imgEl.height winEl.height()

    winEl.trigger 'resize'

    $('#reset').on 'click', ->
      localStorage.clear()
      location.href = '/remote.html'
      false
      
  onPaired: ->
    $('body').addClass 'paired'