module.exports = class Layout
  constructor: ->
    winEl = $(window)
    imgEl = $('#playing img')

    winEl.on 'resize', ->
      imgEl.height winEl.height()

    winEl.trigger 'resize'
      
  onPaired: ->
    $('body').addClass 'paired'