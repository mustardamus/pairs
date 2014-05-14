(function e(t,n,r){function s(o,u){if(!n[o]){if(!t[o]){var a=typeof require=="function"&&require;if(!u&&a)return a(o,!0);if(i)return i(o,!0);throw new Error("Cannot find module '"+o+"'")}var f=n[o]={exports:{}};t[o][0].call(f.exports,function(e){var n=t[o][1][e];return s(n?n:e)},f,f.exports,e,t,n,r)}return n[o].exports}var i=typeof require=="function"&&require;for(var o=0;o<r.length;o++)s(r[o]);return s})({1:[function(require,module,exports){
var Desktop, Encryption, Keys, Layout, PQRCode, Socket;

Socket = require('../socket');

Encryption = require('../encryption');

PQRCode = require('./qrcode');

Layout = require('./layout');

Keys = require('../keys');

Desktop = (function() {
  function Desktop() {
    this.socket = new Socket;
    this.encryption = new Encryption;
    this.qrCode = new PQRCode;
    this.layout = new Layout;
    this.keys = new Keys;
    $('#visual-key-recreate').on('click', (function(_this) {
      return function() {
        _this.generateQRCode();
        return false;
      };
    })(this));
    this.generateQRCode();
    this.socket.io.on('paired', (function(_this) {
      return function() {
        return _this.layout.onPaired();
      };
    })(this));
    this.socket.io.on('stats', (function(_this) {
      return function(stats) {
        return _this.layout.updateStats(stats);
      };
    })(this));
    this.socket.io.emit('connect', {
      pairId: this.keys.pairId,
      deviceType: 'desktop'
    });
    this.socket.io.on('message', (function(_this) {
      return function(data) {
        var event, selector;
        selector = _this.encryption.decryptAes(data.selector, _this.keys.encryptionKey);
        event = _this.encryption.decryptAes(data.event, _this.keys.encryptionKey);
        return $(selector).trigger(event);
      };
    })(this));
    $('#slider').on('cycle-after', (function(_this) {
      return function(e, opt, slideOutEl, slideInEl) {
        var data, imgSrc;
        imgSrc = $(slideInEl).attr('src');
        data = _this.encryption.encryptAes(imgSrc, _this.keys.encryptionKey);
        return _this.socket.io.emit('message', {
          pairId: _this.keys.pairId,
          name: 'update',
          data: data
        });
      };
    })(this));
  }

  Desktop.prototype.generateQRCode = function() {
    var visualKey;
    visualKey = this.keys.generateVisualKey();
    this.qrCode.generateCode(this.keys.pairId, this.keys.encryptionKey, visualKey);
    return this.layout.setVisualKey(visualKey);
  };

  return Desktop;

})();

jQuery(function() {
  return new Desktop;
});


},{"../encryption":4,"../keys":5,"../socket":6,"./layout":2,"./qrcode":3}],2:[function(require,module,exports){
var Layout;

module.exports = Layout = (function() {
  function Layout() {
    var markCurrentWhoopy, navAs, sectionEls, sliderEl, tryOutEl;
    this.winEl = $(window);
    this.bannerEl = $('#banner');
    this.qrEl = $('#top-wrapper');
    this.navigationEl = $('#navigation-wrapper');
    tryOutEl = $('#navigation a:first', this.navigationEl);
    navAs = $('#navigation a', this.navigationEl);
    this.qrEl.waypoint((function(_this) {
      return function(dir) {
        if (dir === 'down') {
          return _this.downsizeBanner();
        } else {
          _this.upsizeBanner();
          navAs.removeClass('current');
          return tryOutEl.addClass('current');
        }
      };
    })(this), {
      offset: -100
    });
    navAs.not(':first').smoothScroll({
      speed: 200
    });
    markCurrentWhoopy = function(el) {
      var id;
      id = el.attr('id');
      navAs.removeClass('current');
      return navAs.parent().find("a[href='#" + id + "']").addClass('current');
    };
    $('.try-it-out').hover((function(_this) {
      return function() {
        return _this.bannerEl.addClass('shake shake-little shake-constant');
      };
    })(this), (function(_this) {
      return function() {
        return _this.bannerEl.removeClass('shake shake-little shake-constant');
      };
    })(this)).on('click', function() {
      $('html,body').animate({
        scrollTop: 0
      }, 'fast', function() {
        navAs.removeClass('current');
        return tryOutEl.addClass('current');
      });
      return false;
    });
    sectionEls = $('#content .section');
    sectionEls.waypoint(function(dir) {
      if (dir === 'down') {
        return markCurrentWhoopy($(this));
      }
    }, {
      offset: 50
    });
    sectionEls.waypoint(function(dir) {
      if (dir === 'up') {
        return markCurrentWhoopy($(this));
      }
    }, {
      offset: '-80%'
    });
    sliderEl = $('#slider');
    sliderEl.cycle({
      timeout: 1000,
      prev: '#slider-prev',
      next: '#slider-next'
    });
    sliderEl.on('cycle-after', (function(_this) {
      return function(e, opt, slideOutEl, slideInEl) {
        var imgSrc;
        imgSrc = $(slideInEl).attr('src');
        return $('#current-image img').attr('src', imgSrc);
      };
    })(this));
    sliderEl.cycle('pause');
    $('#slider-play').on('click', function() {
      var el;
      el = $(this);
      if (el.hasClass('playing')) {
        sliderEl.cycle('pause');
        el.removeClass('playing');
        el.html('<i class="fa fa-play"></i>');
      } else {
        sliderEl.cycle('resume');
        el.addClass('playing');
        el.html('<i class="fa fa-pause"></i>');
      }
      return false;
    });
  }

  Layout.prototype.downsizeBanner = function() {
    this.bannerEl.animate({
      height: 110
    }, 'fast');
    $('img', this.bannerEl).animate({
      top: '-300px'
    }, 'fast');
    this.navigationEl.animate({
      top: '-15px'
    }, 'fast', (function(_this) {
      return function() {
        return _this.navigationEl.addClass('small');
      };
    })(this));
    return this.qrEl.fadeOut(100);
  };

  Layout.prototype.upsizeBanner = function() {
    this.bannerEl.animate({
      height: '80%'
    }, 'fast');
    $('img', this.bannerEl).animate({
      top: '-100px'
    }, 'fast');
    this.navigationEl.animate({
      top: '80%'
    }, 'fast', (function(_this) {
      return function() {
        return _this.navigationEl.removeClass('small');
      };
    })(this));
    return this.qrEl.fadeIn(100);
  };

  Layout.prototype.laterBoy = function() {
    var overlayEl;
    $('#phone-wrapper').css('margin-top', $(window).height());
    overlayEl = $('#overlay');
    $('#button-dim').click(function() {
      var spanEl;
      spanEl = $(this).children('span');
      if (overlayEl.css('display') === 'none') {
        overlayEl.fadeIn('slow');
        spanEl.text('On');
        spanEl.addClass('dim-on');
        spanEl.removeClass('dim-off');
      } else {
        overlayEl.fadeOut('slow');
        spanEl.text('Off');
        spanEl.addClass('dim-off');
        spanEl.removeClass('dim-on');
      }
      return false;
    });
    $('#steps li').on('click', function() {
      var liEl;
      liEl = $(this);
      $('#steps .open').removeClass('open');
      return liEl.addClass('open');
    });
    $('<img src="images/remotes_bg_min.png">').on('load', function() {
      overlayEl.fadeOut(1200);
      $('body').css('overflow', 'auto');
      return $('#loading').fadeOut(800);
    });
    $('#haeh').on('click', function() {
      $('#credits').fadeIn('fast');
      return $(this).fadeOut('fast');
    });
    $('#credits .close').on('click', function() {
      $(this).parent().fadeOut('fast');
      return $('#haeh').fadeIn('fast');
    });
    $('#right-wrapper').css({
      height: $(window).height(),
      overflow: 'hidden'
    });
    this.statsEl = $('#stats');
    this.visitsEl = $('#stats-visits', this.statsEl);
    return this.pairsEl = $('#stats-pairings', this.statsEl);
  };

  Layout.prototype.updateStats = function(stats) {
    this.visitsEl.text(stats.visits);
    this.pairsEl.text(stats.pairs);
    return this.statsEl.fadeIn('slow');
  };

  Layout.prototype.onPaired = function() {
    var scrollEl;
    scrollEl = $('html,body');
    return scrollEl.animate({
      scrollTop: 200
    }, 'fast', function() {
      $('body').addClass('paired');
      return setTimeout(function() {
        return scrollEl.animate({
          scrollTop: 0
        }, 'fast');
      }, 100);
    });
  };

  Layout.prototype.setVisualKey = function(visualKey) {
    return $('#visual-key').text(visualKey);
  };

  return Layout;

})();


},{}],3:[function(require,module,exports){
var Encryption, PQRCode;

Encryption = require('../encryption');

module.exports = PQRCode = (function() {
  function PQRCode() {
    this.encryption = new Encryption;
    this.qrEl = $('#qr-code');
    this.qrCode = new QRCode(this.qrEl.get(0), {
      text: 'pairs.io',
      width: 300,
      height: 300
    });
    this.rootUrl = 'http://192.168.0.11:9000';
    if (location.hostname === 'pairs.io') {
      this.rootUrl = 'http://pairs.io';
    }
  }

  PQRCode.prototype.generateCode = function(pairId, encryptionKey, visualKey) {
    var data, encrypted, json;
    json = JSON.stringify({
      pId: pairId,
      eKey: encryptionKey
    });
    encrypted = this.encryption.encryptAes(json, visualKey);
    data = Base64.encode(encrypted);
    this.qrCode.clear();
    this.qrCode.makeCode("" + this.rootUrl + "/remote.html#" + data);
    return this.qrEl.attr('title', '');
  };

  return PQRCode;

})();


},{"../encryption":4}],4:[function(require,module,exports){
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


},{}],5:[function(require,module,exports){
var Encryption, Keys;

Encryption = require('./encryption');

module.exports = Keys = (function() {
  function Keys() {
    this.encryption = new Encryption;
    this.initKey('pairId');
    this.initKey('encryptionKey');
    this.visualKey = this.generateVisualKey();
  }

  Keys.prototype.initKey = function(keyName) {
    var key;
    key = localStorage.getItem(keyName);
    if (!key) {
      key = this.encryption.randString();
    }
    return this.setKey(keyName, key);
  };

  Keys.prototype.setKey = function(keyName, value) {
    localStorage.setItem(keyName, value);
    return this[keyName] = value;
  };

  Keys.prototype.generateVisualKey = function() {
    this.visualKey = this.encryption.randString(5);
    return this.visualKey;
  };

  Keys.prototype.decryptWithVisualKey = function(key, base64) {
    var decData, e, encData, json, valid;
    valid = false;
    try {
      encData = Base64.decode(base64);
      decData = this.encryption.decryptAes(encData, key);
      json = JSON.parse(decData);
      this.setKey('pairId', json.pId);
      this.setKey('encryptionKey', json.eKey);
      this.visualKey = key;
      valid = true;
    } catch (_error) {
      e = _error;
    }
    return valid;
  };

  Keys.prototype.clear = function() {
    return localStorage.clear();
  };

  return Keys;

})();


},{"./encryption":4}],6:[function(require,module,exports){
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


},{}]},{},[1])