class API::Websocket < Base

  get '/websocket' do
    ws = Faye::WebSocket.new env, nil, ping: 10000

    ws.on :open do |_event|
      websockets.add_client ws
    end

    ws.on :message do |event|
      message = JSON.parse event.data, symbolize_names: true
      @current_user = verify_authtoken message[:token]
      if @current_user
        case message[:event]
          when 'device.state'
            device = device_manager.device_by_id message[:data][:id]
            if can? :control, device
              device.put_state message[:data][:state]
            end
          when 'device.reconnect'
            device = device_manager.device_by_id message[:id]
            if can? :control, device
              device.disconnect
              device.connect
            end
        end
      end
    end

    ws.on :close do |_event|
      websockets.remove_client ws
      ws = nil
    end

    ws.rack_response
    status -1
    ''
  end

  helpers do
    inject :websockets
    inject :device_manager
  end
end
