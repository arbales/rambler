(function() {
  var Rambler, chat, m;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  this.Rambler = Rambler = {
    Models: {}
  };
  Rambler.client = new Faye.Client('/live');
  m = Rambler.Models;
  m.Channel = (function() {
    function Channel(name) {
      var _ref;
            if ((_ref = this.name) != null) {
        _ref;
      } else {
        this.name = name;
      };
      _.bindAll(['receive', 'subscribed', 'failure']);
      this.subscription = Rambler.client.subscribe(this.name, this.receive);
      this.subscription.callback(this.subscribed);
      this.subscription.errback(this.failure);
      this;
    }
    Channel.prototype.receive = function(message) {
      return console.log(message);
    };
    Channel.prototype.subscribed = function() {
      return console.log("Subscribed " + this.name);
    };
    Channel.prototype.failure = function(error) {
      return console.warn(error);
    };
    Channel.prototype.send = function(text) {
      return Rambler.client.publish(this.name, {
        text: text
      });
    };
    Channel.prototype.cancel = function() {
      return this.subscription.cancel();
    };
    return Channel;
  })();
  m.Chat = (function() {
    __extends(Chat, m.Channel);
    function Chat() {
      Chat.__super__.constructor.apply(this, arguments);
    }
    Chat.prototype.name = "/chat";
    Chat.prototype.url = "/chat";
    return Chat;
  })();
  chat = new m.Chat();
  $(document).ready(function() {
    return $('#publisher').submit(function(event) {
      chat.send($('#publisher input').val());
      $('#publisher input').val("");
      return false;
    });
  });
}).call(this);
