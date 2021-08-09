require 'em-websocket'

class ZnServer
  @@_port_number = nil
  @@_message_handler = nil

  def self.default()
    return self
  end

  def self.startDefaultOn_(portNumber)
    @@_port_number = portNumber
    self.start() if @@_message_handler.present?
  end

  def self.delegate_(handler)
    @@_message_handler = handler
    self.start() if @@_port_number.present?
  end

  def self.start()
    raise 'port number is nil' if @@_port_number.nil?
    raise 'message handeler is nil' if @@_message_handler.nil?

    EM.run {
      EM::WebSocket.run(:host => "0.0.0.0", :port=>@@_port_number) do |ws|
        @@_message_handler.call(WebSocketAdapter.new(ws))
      end
    }
  end
end


class ZnWebSocketDelegate
  def self.handler_(proc)
    return proc
  end
end

class WebSocketAdapter
  @_ws = nil

  def initialize(ws)
    @_ws = ws
  end

  def runWith_(proc)
    @_ws.onmessage {|msg|
      proc.call(msg, self)
    }
  end

  def sendResponseInternalServerError_(anAssoc)
  end
end
