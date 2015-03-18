require 'jwt'

module AuthToken

  def AuthToken.issue payload
    payload['exp'] = 1.year.from_now.to_i
    JWT.encode payload, Rails.application.secrets.secret_key_base
  end

  def AuthToken.decode token
    begin
      JWT.decode token, Rails.application.secrets.secret_key_base
    rescue
      nil
    end
  end

end
