(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Encryption;

module.exports = Encryption = (function() {
  function Encryption() {}

  Encryption.prototype.randString = function(length) {
    if (length == null) {
      length = 16;
    }
    return Math.random().toString(36).substr(2, length);
  };

  Encryption.prototype.encryptAes = function(data, key) {
    return GibberishAES.enc(data, key);
  };

  Encryption.prototype.decryptAes = function(data, key) {
    return GibberishAES.dec(data, key);
  };

  return Encryption;

})();


},{}],2:[function(require,module,exports){
var Encryption, Remote, Socket;

Socket = require('../socket');

Encryption = require('../encryption');

Remote = (function() {
  function Remote() {
    var self;
    this.socket = new Socket;
    this.encryption = new Encryption;
    this.socket.io.on('remote:paired', (function(_this) {
      return function() {
        return _this.onPaired();
      };
    })(this));
    this.encHashData = location.hash.split('#').join('');
    $('#visual-code').on('submit', (function(_this) {
      return function(e) {
        var key;
        key = $('#visual-code-input').val();
        e.preventDefault();
        false;
        return _this.encodeAndConnect(key);
      };
    })(this));
    $('#visual-code-input').focus();
    self = this;
    $('#button-dim').click(function() {
      var spanEl;
      spanEl = $(this).children('span');
      if (spanEl.text() === 'Off') {
        spanEl.text('On');
        spanEl.addClass('dim-on');
        spanEl.removeClass('dim-off');
      } else {
        spanEl.text('Off');
        spanEl.addClass('dim-off');
        spanEl.removeClass('dim-on');
      }
      self.sendCommand({
        command: 'dim',
        event: 'click',
        selector: '#button-dim'
      });
      return false;
    });
  }

  Remote.prototype.connectToServer = function() {
    return this.socket.io.emit('remote:connect', {
      connectionKey: this.connectionKey
    });
  };

  Remote.prototype.sendCommand = function(data) {
    var command, event, selector;
    command = this.encryption.encryptAes(data.command, this.encryptionKey);
    event = this.encryption.encryptAes(data.event, this.encryptionKey);
    selector = this.encryption.encryptAes(data.selector, this.encryptionKey);
    return this.socket.io.emit('remote:command', {
      command: command,
      event: event,
      selector: selector,
      connectionKey: this.connectionKey
    });
  };

  Remote.prototype.encodeAndConnect = function(key) {
    var base64, decData, e, good, obj;
    good = false;
    try {
      base64 = Base64.decode(this.encHashData);
      decData = this.encryption.decryptAes(base64, key);
      obj = JSON.parse(decData);
      this.connectionKey = obj.ck;
      this.encryptionKey = obj.ek;
      good = true;
    } catch (_error) {
      e = _error;
      null !== null;
    }
    if (good) {
      return this.connectToServer();
    }
  };

  Remote.prototype.onPaired = function() {
    $('.logo').addClass('paired');
    return $('body').addClass('isPaired');
  };

  return Remote;

})();

jQuery(function() {
  return new Remote;
});


},{"../encryption":1,"../socket":3}],3:[function(require,module,exports){
var Socket;

module.exports = Socket = (function() {
  Socket.prototype.socketUrl = 'http://192.168.0.11:12222';

  function Socket() {
    if (location.hostname === 'pairs.io') {
      this.socketUrl = 'http://pairs.io:12222';
    }
    this.io = io.connect(this.socketUrl);
  }

  return Socket;

})();


},{}]},{},[2])