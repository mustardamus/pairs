desktopFunc = (desktop, remote) ->                    
  routes: { 'dim': 'onDimCommand' }                   # coming in from remote
  events: { 'click #demo #btn-dim': 'onDimClick' }    # desktop DOM events

  initialize: ->                                      # execute on paired
    $('#pair-status').text 'Paired!'

  onDim: (data) ->
    $('#overlay').fadeTo 'fast', data.opacity

  onDimClick: ->
    @onDim { opacity: 0.9 }
    remote.emit 'dimmed'                              # send command to remote

remoteFunc = (desktop, remote) ->
  routes: { 'dimmed': 'onDimmed' }                    # coming in from desktop
  events: { 'click #remote #btn-dim': 'onDimClick' }  # phone DOM events

  initialize: ->
    $('#pair-status').text 'Paired!'

  onDimmed: ->
    $('#dim-status').text 'Is dimmed'

  onDimClick: ->
    desktop.emit 'dim', { opacity: 0.9 }              # send command + data to
                                                      # desktop

Pairs 'pairs.io', desktopFunc, remoteFunc             # setup remote control



