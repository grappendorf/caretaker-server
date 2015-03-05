class WlanMaster

  def initialize
    @message_listeners = []
  end

  def start
    Rails.logger.info 'WLAN master starting'

    # Every message from a device is sent as a UDP message to port 2000
    # We call every message listener with the message parameters

    @message_socket = UDPSocket.new
    @message_receiver = Thread.new do
      begin
        @message_socket.do_not_reverse_lookup = true
        @message_socket.bind '0.0.0.0', '2000'
        loop do
          data, addr = @message_socket.recvfrom 1024
          device_address = addr[3].force_encoding('UTF-8')
          msg, *params = data.split(';')[0].split(',').map{|d| d.force_encoding('UTF-8')}
          @message_listeners.each do |l|
            l.call device_address, msg.to_i, params
          end
        end
      rescue => x
        Rails.logger.error x
      end
    end

    # A broadcast message is sent by a device in two situations:
    # - a known device was powered up
    # - a knew device was configured and has connected to the network
    # We send a response containing the server ip address

    @broadcast_receiver = Thread.new do
      begin
        @broadcast_socket = UDPSocket.new
        @broadcast_socket.do_not_reverse_lookup = true
        @broadcast_socket.bind '0.0.0.0', 55555
        loop do
          data, addr = @broadcast_socket.recvfrom 1024
          device_address = addr[3]
          device_name = data[60..91].unpack('Z*')[0]
          Rails.logger.debug "UDP broadcast from device #{device_name} at #{device_address}"
          @broadcast_socket.send "*SERVER*\n192.168.1.1\n", 0, device_address, 2000
        end
      rescue => x
        Rails.logger.error x
      end
    end
  end

  def stop
    Rails.logger.info 'WLAN master stopping'

    @message_receiver.exit
    @broadcast_receiver.exit
  end

  def send_message address, msg, params = []
    Rails.logger.debug "#{msg}#{',' unless params.empty?}#{params.join ','}; -> #{address}"
    @message_socket.send "#{msg}#{',' unless params.empty?}#{params.join ','};\n", 0, address, 2000
  end

  def when_message_received &block
    @message_listeners << block
  end

end