module.exports = class Layout
  constructor: ->
    $('#visual-code-input').focus()
    # prompt() # shortcut und vom browser gestylt!

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

      false

  onPaired: ->
    $('.logo').addClass 'paired'
    $('body').addClass 'isPaired'