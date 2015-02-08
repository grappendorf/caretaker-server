class AppController < ApplicationController

  layout false

  skip_before_filter :verify_authenticity_token, :only => [:static]

  def index
  end

  def locale
    render json: { locale: I18n.locale, defaultLocale: I18n.default_locale }
  end

  def static
    p params[:path]
    render file: File.join(Rails.root, 'public', params[:path])
  end

end
