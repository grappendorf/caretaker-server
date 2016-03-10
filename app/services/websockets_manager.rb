class WebsocketsManager
  def start
    Grape::API.logger.info 'Websockets Manager starting'
  end

  def stop
    Grape::API.logger.info 'Websockets Manager stopping'
  end

  def add_client client
    clients << client
  end

  def remove_client client
    clients.delete client
  end

  def trigger event, data
    clients.each do |client|
      client.send({
        event: event,
        data: data
      }.to_json)
    end
  end

  def clients
    @clients ||= []
  end
end
