Then /^I should be able to login on "(.+)" with email "(.+)" and password "(.+)"$/ do |path, email, password|
  response = request path, method: :post, input: {
      email: email,
      password: password
    }.to_json
  expect(response.status).to eq(201), "Expected to login with email '#{email}' and password '#{password}'"
end
