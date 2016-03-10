require 'util/log_helpers'
require 'util/params_helpers'
require 'util/auth_helpers'
require 'util/json_error_formatter'

class Base < ::Grape::API
  def self.inherited(subclass)
    super

    subclass.instance_eval do
      format :json
      error_formatter :json, JsonErrorFormatter

      helpers LogHelpers
      helpers ParamsHelpers
      helpers AuthHelpers

      before do
        if env.respond_to? :http_accept_language
          locale = env.http_accept_language.compatible_language_from(I18n.available_locales)
          I18n.locale = locale if locale
        else
          I18n.locale = :en
        end
      end

      rescue_from ::CanCan::AccessDenied do |e|
        error! e.message, 401
      end

      rescue_from ::Grape::Exceptions::ValidationErrors do |e|
        error!(
          {
            error: {
              message: 'Invalid data',
              errors: e.map { |attrs, msg|
                attrs.map { |attr| { attribute: attr.gsub(/\[(.+)\]/, '.\1'), message: msg } }
              }.flatten
            }
          }, 400)
      end

      rescue_from ActiveRecord::RecordInvalid do |e|
        error!(
          {
            error: {
              message: 'Invalid data',
              errors: e.record.errors.messages.map { |attr, msgs|
                msgs.map { |msg| { attribute: attr, message: msg } }
              }.flatten
            }
          }, 400)
      end

      rescue_from ActiveRecord::RecordNotFound do |_e|
        error! 'record not found', 404
      end

      rescue_from :all do |e|
        Base::logger.error e.class.name + "\n" + e.message + "\n" + e.backtrace.join("\n")
        error! e.message
      end
    end
  end
end
