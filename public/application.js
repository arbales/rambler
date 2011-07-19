(function() {
  var Authenticater, Post, Rambler, SourceView, Stream, chat, r;
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; }, __hasProp = Object.prototype.hasOwnProperty, __extends = function(child, parent) {
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
  Authenticater = {
    outgoing: function(message, callback) {
      console.log(message);
      if (message.data && !message.channel.match(/\/meta\//)) {
        message.data.username = "arbales";
      }
      return callback(message);
    }
  };
  Rambler.client.addExtension(Authenticater);
  r.Channel = (function() {
    function Channel(name) {
      this.receive = __bind(this.receive, this);      var _ref;
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
      if (this.stream) {
        console.log(message);
        return this.stream.add(message);
      }
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
  Post = Spine.Model.setup("Post", ['body']);
  SourceView = Spine.Controller.create({
    events: {
      "click .hide": "hide"
    },
    hide: function() {
      $(this.partner_el).toggleClass("expanded");
      return $(this.el).toggleClass("hidden");
    }
  });
  Stream = Spine.Controller.create({
    events: {
      "submit #publisher": "send"
    },
    init: function() {
      var _ref;
      this.messages = (_ref = this.el.find('.messages')) != null ? _ref[0] : void 0;
      return this.channel.stream = this;
    },
    pull: function() {
      return $.ajax({
        url: '/chat/posts',
        success: __bind(function(data) {
          _.each(data, __bind(function(s) {
            return this.add(s);
          }, this));
          if (data.length < 1) {
            return this.add({
              text: "There are no messages in this room.",
              username: "Rambler",
              style: 'initial'
            });
          }
        }, this)
      });
    },
    send: function(event) {
      var target, value;
      target = $(event.currentTarget).find("input");
      value = target.val();
      this.channel.send(value);
      target.val("");
      return false;
    },
    add: function(message) {
      var date, el, msg, row, _ref;
      date = message.date != null ? message.date : (new Date()).toJSON();
      msg = message != null ? (_ref = message.text) != null ? _ref.replace(/(https?:\/\/[^\s]+)/g, function(url) {
        return "<a href='" + url + "'>" + url + "</a>";
      }) : void 0 : void 0;
      el = $("<li>" + msg + "<p class='details'><a class='user' href='/href'>" + message.username + "</a> <time class='timeago' datetime='" + date + "'></time></p></li>");
      row = $(this.messages).append(el);
      el.prev().toggleClass('previous');
      if (message.style) {
        el.addClass(message.style);
      }
      $(el).find('time').timeago();
      $(el).embedly({
        maxHeight: 300,
        wmode: 'transparent',
        method: 'replace'
      });
      $(this.messages).prop("scrollTop", $(this.messages).prop("scrollHeight"));
      return false;
    }
  });
  $(document).ready(function() {
    var sidebar, stream;
    stream = Stream.init({
      el: $('#chat'),
      channel: new r.Chat()
    });
    sidebar = SourceView.init({
      el: $('#source_view'),
      partner_el: $('#chat')
    });
    return stream.pull();
  });
}).call(this);
