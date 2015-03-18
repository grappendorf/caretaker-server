class ApplicationController < ActionController::Base

  require 'auth_token'

  before_filter :verify_jwt_token, except: [:options]

  before_action :set_locale, unless: :json_request?

  before_filter :fix_strong_parameters_for_cancan, only: :create

  rescue_from 'Exception' do |e|
    render status: :internal_server_error, json: { exception: "#{e.class.name}: #{e.message}", }
  end

  rescue_from 'CanCan::AccessDenied' do
    render status: :unauthorized, nothing: true
  end

  protected
  def verify_jwt_token
    begin
      token = AuthToken.decode request.headers['Authorization'].split(' ').last
      @current_user = User.find token[0]['user_id']
    rescue
      head :unauthorized
    end
  end

  private
  def json_request?
    request.format.json?
  end


  private
  def fix_strong_parameters_for_cancan
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  private
  def set_locale
    I18n.locale = extract_locale_from_accept_language_header
  end

  private
  def extract_locale_from_accept_language_header
    accept_language = request.env['HTTP_ACCEPT_LANGUAGE']
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first if accept_language
  end

end