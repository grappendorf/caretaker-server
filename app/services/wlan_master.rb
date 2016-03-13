class WlanMaster
  def initialize
    @message_listeners = []
  end

  def start
    Grape::API.logger.info 'WLAN master starting'

    # Every message from a device is sent as a UDP message to port 2000
    # We call every message listener with the message parameters

    @message_send_socket = UDPSocket.new
    @message_receiver = Thread.new do
      begin
        message_reveice_socket = UDPSocket.new
        message_reveice_socket.do_not_reverse_lookup = true
        message_reveice_socket.bind '0.0.0.0', Application.config.server_port
        loop do
          begin
            data, addr = message_reveice_socket.recvfrom 1024
            device_address = addr[3].force_encoding('UTF-8')
            msg, *params = data.split(';')[0].split(',').map { |d| d.force_encoding('UTF-8') }
            @message_listeners.each do |l|
              l.call device_address, msg.to_i, params
            end
          rescue => x
            Grape::API.logger.error x
          end
        end
      rescue => x
        Grape::API.logger.error x
      end
    end

    # A broadcast message is sent by a device in two situations:
    # - a known device was powered up
    # - a knew device was configured and has connected to the network
    # We send a response containing the server ip address

    @broadcast_receiver = Thread.new do
      begin
        broadcast_socket = UDPSocket.new
        broadcast_socket.do_not_reverse_lookup = true
        broadcast_socket.bind '0.0.0.0', Application.config.broadcast_port
        loop do
          begin
            data, _address = broadcast_socket.recvfrom 1024
            device_name = data[60..91].unpack('Z*')[0]
            Grape::API.logger.debug "UDP broadcast from device #{device_name}"
            broadcast_socket.send "*SERVER*\n#{Application.config.public_ip}\n", 0, device_name,
              Application.config.device_port
          rescue => x
            Grape::API.logger.error x
          end
        end
      rescue => x
        Grape::API.logger.error x
      end
    end
  end

  def stop
    Grape::API.logger.info 'WLAN master stopping'

    @message_receiver.exit
    @broadcast_receiver.exit
  end

  def send_message address, msg, params = []
    @message_send_socket.send "#{msg}#{',' unless params.empty?}#{params.join ','};\n", 0, address,
      Application.config.device_port
  end

  def when_message_received &block
    @message_listeners << block
  end
end
