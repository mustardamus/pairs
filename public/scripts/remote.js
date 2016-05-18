!function t(e,n,r){function i(s,a){if(!n[s]){if(!e[s]){var c="function"==typeof require&&require;if(!a&&c)return c(s,!0);if(o)return o(s,!0);throw new Error("Cannot find module '"+s+"'")}var u=n[s]={exports:{}};e[s][0].call(u.exports,function(t){var n=e[s][1][t];return i(n?n:t)},u,u.exports,t,e,n,r)}return n[s].exports}for(var o="function"==typeof require&&require,s=0;s<r.length;s++)i(r[s]);return i}({1:[function(t,e,n){var r;e.exports=r=function(){function t(){}return t.prototype.randString=function(t){return null==t&&(t=16),Math.random().toString(36).substr(2,t)},t.prototype.encryptAes=function(t,e){return GibberishAES.enc(t,e)},t.prototype.decryptAes=function(t,e){return GibberishAES.dec(t,e)},t}()},{}],2:[function(t,e,n){var r,i;r=t("./encryption"),e.exports=i=function(){function t(){this.encryption=new r,this.initKey("pairId"),this.initKey("encryptionKey"),this.visualKey=this.generateVisualKey()}return t.prototype.initKey=function(t){var e;return e=localStorage.getItem(t),e||(e=this.encryption.randString()),this.setKey(t,e)},t.prototype.setKey=function(t,e){return localStorage.setItem(t,e),this[t]=e},t.prototype.generateVisualKey=function(){return this.visualKey=this.encryption.randString(5),this.visualKey},t.prototype.decryptWithVisualKey=function(t,e){var n,r,i,o,s;s=!1;try{i=Base64.decode(e),n=this.encryption.decryptAes(i,t),o=JSON.parse(n),this.setKey("pairId",o.pId),this.setKey("encryptionKey",o.eKey),this.visualKey=t,s=!0}catch(a){r=a}return s},t.prototype.clear=function(){return localStorage.clear()},t}()},{"./encryption":1}],3:[function(t,e,n){var r;e.exports=r=function(){function t(){var t,e;e=$(window),t=$("#playing img"),e.on("resize",function(){return t.height(e.height())}),e.trigger("resize"),$("#reset").on("click",function(){return localStorage.clear(),location.href="/remote.html",!1})}return t.prototype.onPaired=function(){return $("body").addClass("paired")},t}()},{}],4:[function(t,e,n){var r,i,o,s,a;a=t("../socket"),r=t("../encryption"),i=t("../keys"),o=t("./layout"),s=function(){function t(){var t,e,n;this.socket=new a,this.encryption=new r,this.keys=new i,this.layout=new o,this.socket.io.on("paired",function(t){return function(){return t.layout.onPaired()}}(this)),this.socket.io.on("message",function(t){return function(e){var n,r;return"update"===e.name&&(r=t.encryption.decryptAes(e.data,t.keys.encryptionKey),$("#playing img").attr("src",r),$("html,body").animate({scrollLeft:250},100)),"play"===e.name?(n=$("#play"),n.hasClass("playing")?(n.removeClass("playing"),n.html('<i class="fa fa-play"></i>')):(n.addClass("playing"),n.html('<i class="fa fa-pause"></i>'))):void 0}}(this)),$("#next").on("click",function(t){return function(){return t.socket.io.emit("message",{pairId:t.keys.pairId,name:"next",data:{}}),!1}}(this)),$("#prev").on("click",function(t){return function(){return t.socket.io.emit("message",{pairId:t.keys.pairId,name:"prev",data:{}}),!1}}(this)),t=location.hash,0!==t.length?this.hashData=t.split("#")[1]:localStorage.getItem("pairId")?this.connect():($("#nohash").show(),$("#visual-key-wrapper").hide()),e=$("#visual-key-wrapper .error"),n=$("#visual-key-input"),$("#visual-key-form").on("submit",function(t){return function(r){var i,o;return t.hashData&&(i=n.val(),o=t.keys.decryptWithVisualKey(i,t.hashData),o===!0?(t.connect(),e.hide()):e.show()),r.preventDefault(),!1}}(this)),$("#reset").on("click",function(t){return function(){return t.keys.clear(),!1}}(this)),$("#button-dim").click(function(t){return function(){return t.sendCommand({command:"dim",event:"click",selector:"#button-dim"}),!1}}(this))}return t.prototype.connect=function(){return this.socket.io.emit("connect",{pairId:this.keys.pairId,deviceType:"remote"})},t.prototype.sendCommand=function(t){var e,n,r;return e=this.encryption.encryptAes(t.command,this.keys.encryptionKey),n=this.encryption.encryptAes(t.event,this.keys.encryptionKey),r=this.encryption.encryptAes(t.selector,this.keys.encryptionKey),this.socket.io.emit("message",{command:e,event:n,selector:r,pairId:this.keys.pairId})},t}(),jQuery(function(){return new s})},{"../encryption":1,"../keys":2,"../socket":5,"./layout":3}],5:[function(t,e,n){var r;e.exports=r=function(){function t(){"pairs.akrasia.me"===location.hostname&&(this.socketUrl="http://pairs.akrasia.me:12222"),this.io=io.connect(this.socketUrl)}return t.prototype.socketUrl="192.168.2.105:12222",t}()},{}]},{},[4]);