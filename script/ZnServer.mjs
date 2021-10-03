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
    var r = null;
    if (typeof handler === 'function') {
      r = handler(new ZnRequest(req));
    } else if (handler instanceof ZnDefaultDelegate) {
      r = handler.request(req, res);
    }
    if(r) {
      r.writeOn_(res);
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
      const uri = new ZnUri(req.url);
      ws.uri = function() {
        return uri;
      };
      ws.sendMessage_ = function(msg) {
        this.send(msg);
      };
      self.wss().emit('connection', ws, req);
    });
  }
}

//-----------------------------------------------------------------------------
export class ZnUri {
  _url = null;
  _query = null;
  constructor(url) {
    this._url = url;
  }
  query() {
    if (!this._query) {
      this._query = parse(this._url, true).query;
    }
    return this._query;
  }
  queryAt_(key) {
    return this.query()[key];
  }

  queryAt_ifAbsent_(key, aBlock) {
    return this.query()[key] || aBlock();
  }
  toString() {
    return this._url;
  }
  
}

//-----------------------------------------------------------------------------
export class ZnRequest {
  _entity = null;
  _uri = null;
  constructor(req) {
    this._entity = req;
  }

  uri() {
    if (!this._uri) {
      this._uri = new ZnUri(this._entity.url);
    }
    return this._uri;
  }
  method() {
    return this._entity.method;
  }
}

//-----------------------------------------------------------------------------
export class ZnStatusLine {
  _code = 500;
  constructor(c) {
    this._code = c;
  }
  code() {
    return this._code;
  }
}
ZnStatusLine.ok = function() {
  return new ZnStatusLine(200);
};

ZnStatusLine.internalServerError = function() {
  return new ZnStatusLine(500);
};
ZnStatusLine.notFound = function() {
  return new ZnStatusLine(404);
};


//-----------------------------------------------------------------------------
export class ZnResponse {
  _statusLine = null;
  _entity = null;
  _headers = {};
  statusLine() {
    if (!this._statusLine) {
      this._statusLine = new ZnStatusLine();
    }
    return this._statusLine;
  }
  statusLine_(sl) {
    this._statusLine = sl;
  }
  code() {
    return this.statusLine().code();
  }
  entity() { return this._entity; }
  entity_(e) {
    this._entity = e;
    this._headers['Content-Type'] = e.type();
    this._headers['Content-Length'] = e.length();
  }
  headers_(h) {
    var self = this;

    Object.keys(h).forEach(function(key) {
      self._headers[key] = h[key];
    });

  }

  writeOn_(res) {
    const code = this.code();
    const entity = this.entity();

    res.writeHead(code, this._headers);
    if (entity) {
      res.write(entity.data());
    }
    res.end();
  }
}
ZnResponse.serverErrorWithEntity_ = function(e) {
  const r = new ZnResponse();
  r.statusLine_(ZnStatusLine.internalServerError());
  r.entity_(e);
  return r;
};

ZnResponse.notFound_ = function(path) {
  const r = new ZnResponse();
  r.statusLine_(ZnStatusLine.notFound());
  r.entity_(ZnEntity.text_(path.toString()));
  return r;
};

ZnResponse.statusLine_ = function(statusLine) {
  const r = new ZnResponse();
  r.statusLine_(statusLine);
  return r;
}


String.prototype.asZnUrl = function() {
  return new ZnUri(this);
}

//-----------------------------------------------------------------------------
export class ZnHeaders {
}
ZnHeaders.defaultResponseHeaders = function() {
  return {};
};

//-----------------------------------------------------------------------------
export class ZnEntity {
  _type = null;
  _data = null;
  type() {
    if(!this._type) {
      this._type = 'text/plain';
    }
    return this._type;
  }
  type_(t) { this._type = t; }
  data() { return this._data; }
  data_(d) { this._data = d; }
  length() {
    if (this.data()) {
      return this.data().length;
    }
    return 0;
  }
}
ZnEntity.text_ = function(t) {
  const e = new ZnEntity();
  e.type_('text/plain');
  e.data_(t);
  return e;
};

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
