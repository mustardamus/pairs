remotes picture: https://secure.flickr.com/photos/79818573@N04/10730490594/sizes/k/
phone picture: http://dribbble.com/shots/1193973-Flat-Nexus-4-Phone

Enable fallback: https://stackoverflow.com/questions/7071263/socket-io-v0-7-where-to-put-flashsockets-swf-file

css spinners: http://css-spinners.com/#/spinner/gauge/


## Wie könnte eine Fernbedienung programmiert werden

Alles auf eine ebene oder devices teilen?!

    Pairs 'demo', (desktop, remote) ->
      desktop:
        routes:
          'dim': 'onDim'

        events:
          'click #btn-dim': 'onBtnClick'

        initialize: ->
          @dimEl = overlay

        onDim: (data) ->
          @dimEl.fadeTo data.fade

        onBtnClick: (e) ->
          remote.emit 'button:clicked'

      remote:
        routes:
          'button:clicked': 'onBtnClicked'

        events:
          'click #btn-dim-remote': 'onBtnClick'

        initialize: ->
          @btnEl = $('#btn-dim-remote')

        onBtnClicked: ->
          @btnEl.toggleClass 'on'

        onBtnClick: ->
          desktop.emit 'dim', { fade: 0.8 }