require 'spec_helper'

describe API::Status do
  describe 'GET /status' do
    it 'returns ok if accessible' do
      get '/status'
      expect(response.body).to be_json_eql '{"status": "ok"}'
    end
  end
end
