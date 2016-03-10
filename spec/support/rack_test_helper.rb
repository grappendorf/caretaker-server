module RackTestHelper

  include Rack::Test::Methods
  include JsonSpec::Helpers

  def app
    subject
  end

  def response
    last_response
  end

  def response_json
    JSON.parse(response.body, max_nesting: 19)
  end

end

RSpec.configure do |config|
  config.include RackTestHelper, type: :rack, file_path: /spec\/api/
end
