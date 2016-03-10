class API::Sessions < Base

  namespace '/sessions' do

    desc 'Login with email and password, returns a JSON Web Token (JWT) if valid'
    params do
      requires :email, type: String, desc: 'The user\'s email'
      requires :password, type: String, desc: 'The user\'s password'
    end
    post '/' do
      user = authenticate_user! params[:email], params[:password]
      token = issue_authtoken id: user.id.to_s, roles: user.roles.map(&:name)
      {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          roles: user.roles.map(&:name)
        },
        token: token
      }
    end
  end
end
