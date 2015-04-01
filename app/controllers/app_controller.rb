class AppController < ApplicationController

  skip_before_filter :verify_jwt_token

  def index
  end

  def locale
    render json: { locale: I18n.locale, defaultLocale: I18n.default_locale }
  end

  def static
    render file: File.join(Rails.root, 'public', params[:path])
  end

  def not_found
    render status: :not_found, nothing: true
  end

end
