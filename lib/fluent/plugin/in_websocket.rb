require 'fluent/input'
require 'em-websocket'

module Fluent
  VERSION = "0.12.19"
  class InWebsocket < Input
    # First, register the plugin. NAME is the name of this plugin
    # and identifies the plugin in the configuration file.
    Fluent::Plugin.register_input('in_websocket', self)

    # config_param defines a parameter. You can refer a parameter via @port instance variable
    # :default means this parameter is optional
    config_param :port, :integer, default: '8080'
    config_param :host, :integer, default: '127.0.0.1'

    # This method is called before starting.
    # 'conf' is a Hash that includes configuration parameters.
    # If the configuration is invalid, raise Fluent::ConfigError.
    def configure(conf)
      super

      # You can also refer to raw parameter via conf[name].
      @port = conf['port']
      @host = conf['host']
    end

    # This method is called when starting.
    # Open sockets or files and create a thread here.
    def start
      super
      Thread.new(&method(:run))
    end

    def run
      EM.run {
        EM::WebSocket.run(host: @host, port: @port) do |ws|
          ws.onopen { |handshake|
            puts "WebSocket connection open"

            # Access properties on the EM::WebSocket::Handshake object, e.g.
            # path, query_string, origin, headers

            # Publish message to the client
            ws.send "Hello Client, you connected to #{handshake.path}"
          }

          ws.onclose { puts "Connection closed" }

          ws.onmessage { |msg|
            puts "Recieved message: #{msg}"
            data = JSON.parse(msg)
            router.emit(data.label, Engine.now, data.record)

            ws.send "Pong: #{msg}"
          }
        end
      }
    end

    # This method is called when shutting down.
    # Shutdown the thread and close sockets or files here.
    def shutdown
      puts 'SHOULD CLOSE DOWN CONNECTION'
    end
  end
end
