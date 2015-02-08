def sign_in user, password: 'password'
  post '/session/sign_in.json', "user[email]=#{user.email}&user[password]=#{password}"
end

def sign_out
  get '/sessions/sign_out.json'
end
