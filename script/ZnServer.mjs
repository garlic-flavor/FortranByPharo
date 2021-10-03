import {createServer} from 'http';
import {parse} from 'url';
import {WebSocketServer} from 'ws';

//-----------------------------------------------------------------------------
export class ZnServer {
  _portNumber = null;
  _delegate = null;
  _server = null;

  portNumber() {
    if(!this._portNumber) { this._portNumber = 50000; }
    return this._portNumber;
  }
  portNumber_(p) { this._portNumber = p; }

  delegate() {
    if (!this._delegate) { this._delegate = new ZnDefaultDelegate(); }
    return this._delegate;
  }
  delegate_(d) {
    this._delegate = d;
  }

  server() {
    if (!this._server){ this._server = createServer(); }
    return this._server;
  }
  server_(s) {
    this._server = s;
  }

  start() {
    const self = this;
    var s = this.server();
    s.on('request', function(req, res) {
      self.delegate().request(req, res);
    });
    s.on('upgrade', function(req, sock, head) {
      self.delegate().upgrade(req, sock, head);
    });
    s.listen(this._portNumber);
  }
};

ZnServer._default = null;
ZnServer.default = function() {
  if(!ZnServer._default) {
    ZnServer._default = new ZnServer();
  } 
  return ZnServer._default;
};

ZnServer.startDefaultOn_ = function(portNumber) {
  var s = ZnServer.default();
  s.portNumber_(portNumber);
  s.start();
};

//-----------------------------------------------------------------------------
export class ZnDefaultDelegate {
  _map = {};
  _handler = null;

  map_to_(path, handler) {
    this._map['/' + path] = handler;
  }
  getHandlerFor(req) {
    return this._handler || this._map[parse(req.url).pathname];
  }

  handler_(h) { this._handler = h; }

  request(req, res) {
    var handler = this.getHandlerFor(req);
    if (typeof handler === 'function') {
      handler(req, res);
    } else if (handler instanceof ZnDefaultDelegate) {
      handler.request(req, res);
    }
  }
  upgrade(req, sock, head) {
    var handler = this.getHandlerFor(req);
    if (handler instanceof ZnDefaultDelegate) {
      handler.upgrade(req, sock, head);
    }
  }

}
ZnDefaultDelegate.handler_ = function(h) {
  const d = new this();
  d.handler_(h);
  return d;
};
//-----------------------------------------------------------------------------
export class SWWebSocketDelegate extends ZnDefaultDelegate {
  _wss = null;

  wss() {
    if(!this._wss){
      var self = this;
      this._wss = new WebSocketServer({noServer: true});
      this._wss.on('connection', function(ws) {
        self._handler && self._handler(ws);
      });
    }
    return this._wss;
  }
  wss_(s){
    this._wss = s;
  }
  upgrade(req, sock, head) {
    const self = this;
    this.wss().handleUpgrade(req, sock, head, function(ws) {
      ws.uri = function() {
        var url = parse(req.url, true);
        url.queryAt_ = function(key) {
          return this.query[key];
        };
        url.queryAt_ifAbsent_ = function(key, def) {
          return this.query[key] || def;
        };
        url.toString = function() {
          return req.url;
        };
        return url;
      };
      ws.sendMessage_ = function(msg) {
        this.send(msg);
      };
      self.wss().emit('connection', ws, req);
    });
  }
}


//-----------------------------------------------------------------------------
export class WebSocketAdapter {
}

//-----------------------------------------------------------------------------
if (process.env.NODE_ENV === 'test') {
  ZnServer.startDefaultOn_(50000);
  var del = ZnServer.default().delegate();
  del.map_to_('manage', function(req, res) {
    res.writeHead(200, { 'Content-Type': 'text/plain' });
    res.write('Hello, world!');
    res.end();
  });

  var wsd = new ZnWebSocketDelegate();
  wsd.handler_(function(ws) {
    ws.on('message', function(message) {
      console.log('received: %s', message);
      ws.send('received message is: ' + message);
    });
  });
  del.map_to_('execute', wsd);
}
