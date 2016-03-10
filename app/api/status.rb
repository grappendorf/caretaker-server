class API::Status < Base

  get ['/', '/status'] do
    {
      status: 'ok'
    }
  end

  get '/version' do
    require_relative '../../lib/version'
    {
      short: VERSION
    }
  end
end
