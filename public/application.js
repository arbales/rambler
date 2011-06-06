(function() {
  var Rambler, Stream, chat, r;
  var __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
    for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; }
    function ctor() { this.constructor = child; }
    ctor.prototype = parent.prototype;
    child.prototype = new ctor;
    child.__super__ = parent.prototype;
    return child;
  };
  this.Rambler = Rambler = {
    Models: {},
    Views: {},
    Resources: {}
  };
  Rambler.client = new Faye.Client('/live');
  r = Rambler.Resources;
  r.Channel = (function() {
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
  r.Chat = (function() {
    __extends(Chat, r.Channel);
    function Chat() {
      Chat.__super__.constructor.apply(this, arguments);
    }
    Chat.prototype.name = "/chat";
    Chat.prototype.url = "/chat";
    return Chat;
  })();
  chat = new r.Chat();
  Stream = Spine.Controller.create({
    events: {
      "submit #publisher": "send"
    },
    init: function() {
      var _ref;
      return this.messages = (_ref = this.el.find('.messages')) != null ? _ref[0] : void 0;
    },
    send: function(event) {
      var d, target, value;
      target = $(event.currentTarget).find("input");
      value = target.val();
      this.stream.send(value);
      d = new Date();
      $(this.messages).append("<li>" + value + "<p class='details'><a class='user' href='/href'>username</a> <time class='timeago' datetime='" + (d.format('isoDateTime')) + "'></time></p></li>");
      $(this.messages).prop("scrollTop", $(this.messages).prop("scrollHeight"));
      $(this.el).find('time').timeago();
      target.val("");
      return false;
    }
  });
  $(document).ready(function() {
    var stream;
    return stream = Stream.init({
      el: $('#chat'),
      stream: new r.Chat()
    });
  });
}).call(this);
