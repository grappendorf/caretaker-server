require 'bcrypt'
require 'jwt'

module AuthHelpers
  def current_user
    @current_user ||= verify_authtoken!
  end

  def authenticate_user! email, password
    begin
      User.find_by!(email: email).tap do |user|
        user.authenticate! password
      end
    rescue ActiveRecord::RecordNotFound, BCrypt::Errors::InvalidSecret
      error! 'Invalid credentials', 401
    end
  end

  def verify_authtoken! token = nil
    verify_authtoken(token) or error!('Invalid credentials', 401)
  end

  def verify_authtoken token = nil
    token = token || request.headers['Authorization']
    return nil unless token
    payload, _header = decode_authtoken token
    if valid_payload?(payload)
      User.find payload['id']
    else
      nil
    end
  end

  def valid_payload?(payload)
    payload.has_key?('id') && payload.has_key?('roles')
  end

  def issue_authtoken payload
    payload['exp'] = Application.config.jwt_expiration.from_now.to_i
    JWT.encode payload, Application.config.secret_key_base
  end

  def decode_authtoken token
    begin
      JWT.decode token, Application.config.secret_key_base
    rescue
      error! 'Invalid credentials', 401
    end
  end
end
