// Generated by CoffeeScript 1.7.1

/*
WebSocket Interface for the WebSocketRails client.
 */

(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  WebSocketRails.WebSocketConnection = (function() {
    function WebSocketConnection(url, dispatcher) {
      this.url = url;
      this.dispatcher = dispatcher;
      this.flush_queue = __bind(this.flush_queue, this);
      this.on_error = __bind(this.on_error, this);
      this.on_close = __bind(this.on_close, this);
      this.on_message = __bind(this.on_message, this);
      this.trigger = __bind(this.trigger, this);
      if (this.url.match(/^wss?:\/\//)) {
        console.log("WARNING: Using connection urls with protocol specified is depricated");
      } else if (window.location.protocol === 'http:') {
        this.url = "ws://" + this.url;
      } else {
        this.url = "wss://" + this.url;
      }
      this.message_queue = [];
      this._conn = new WebSocket(this.url);
      this._conn.onmessage = this.on_message;
      this._conn.onclose = this.on_close;
      this._conn.onerror = this.on_error;
    }

    WebSocketConnection.prototype.trigger = function(event) {
      if (this.dispatcher.state !== 'connected') {
        return this.message_queue.push(event);
      } else {
        return this._conn.send(event.serialize());
      }
    };

    WebSocketConnection.prototype.on_message = function(event) {
      var data;
      data = JSON.parse(event.data);
      return this.dispatcher.new_message(data);
    };

    WebSocketConnection.prototype.on_close = function(event) {
      var close_event;
      close_event = new WebSocketRails.Event(['connection_closed', event]);
      this.dispatcher.state = 'disconnected';
      return this.dispatcher.dispatch(close_event);
    };

    WebSocketConnection.prototype.on_error = function(event) {
      var error_event;
      error_event = new WebSocketRails.Event(['connection_error', event]);
      this.dispatcher.state = 'disconnected';
      return this.dispatcher.dispatch(error_event);
    };

    WebSocketConnection.prototype.flush_queue = function() {
      var event, _i, _len, _ref;
      _ref = this.message_queue;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        event = _ref[_i];
        this._conn.send(event.serialize());
      }
      return this.message_queue = [];
    };

    return WebSocketConnection;

  })();

}).call(this);