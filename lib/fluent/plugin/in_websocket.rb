require 'fluent/input'
require 'em-websocket'

module Fluent
  class WebsocketInput < Input
    # First, register the plugin. NAME is the name of this plugin
    # and identifies the plugin in the configuration file.
    Plugin.register_input('websocket', self)

    # config_param defines a parameter. You can refer a parameter via @port instance variable
    # :default means this parameter is optional
    config_param :port, :integer, default: 8080
    config_param :host, :string, default: '127.0.0.1'

    # This method is called before starting.
    # 'conf' is a Hash that includes configuration parameters.
    # If the configuration is invalid, raise Fluent::ConfigError.
    def configure(conf)
      super
    end

    # This method is called when starting.
    # Open sockets or files and create a thread here.
    def start
      super
      @thread = Thread.new do
        run
      end
    end

    def log_message text
      $log.info text
    end

    def run
      EM.run {
        log_message "EM will be runned on #{@host}:#{@port}"
        EM::WebSocket.run(host: @host, port: @port) do |ws|
          ws.onopen { |handshake|
            log_message "WebSocket connection open"
            ws.send "Hello Client, you connected to #{handshake.path}"
          }

          ws.onerror { |e|
            log_message "error occured"
            log_message "error: #{e}"
           }

          ws.onclose { |e|
            log_message "Connection closed"
            log_message "reason: #{e}"
           }

          ws.onmessage { |msg|
            log_message "Recieved message: #{msg}"
            data = JSON.parse(msg)
            router.emit(data['label'], Engine.now, data['record'])
            ws.send "Pong: #{msg}"
          }
        end
      }
    end

    # This method is called when shutting down.
    # Shutdown the thread and close sockets or files here.
    def shutdown
      super
      EM.stop
      Thread::kill(@thread)
      log_message 'closed EM and thread'
    end
  end
end
