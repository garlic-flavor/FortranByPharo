
const app = require('express')();
const ws = require('ws');

class ZnServer {}
ZnServer.startDefaultOn_ = function(portNumber) {
  app.listen(portNumber);
};




class ZnWebSocketDelegate {
}

class WebSocketAdapter {
}


export { ZnServer, ZnWebSocketDelegate, WebSocketAdapter };
