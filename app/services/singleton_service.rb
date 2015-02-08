require 'drb'
require 'drb/acl'

class SingletonService

  module SingletonServiceClassMixin
    def uri_file
      "#{Dir.tmpdir}/#{Rails.application.engine_name}-#{name}.uri"
    end
  end

  module SingletonServiceInstanceMixin
    attr_accessor :server

    def start
    end

    def stop
      server.stop_service
      FileUtils.rm_f self.class.uri_file
    end

  end

  extend SingletonServiceClassMixin
  include SingletonServiceInstanceMixin

  def self.new
    if File.exist? uri_file
      create_proxy_service
    else
      if block_given?
        service = yield
        service.class.extend SingletonServiceClassMixin
        service.extend SingletonServiceInstanceMixin
      else
        service = super
      end
      start_service service
      service
    end
  end

  def self.start_service service
    DRb.install_acl ACL.new %w[allow 127.0.0.1 deny all]
    service.server = DRb.start_service nil, service
    File.write service.class.uri_file, service.server.uri
  end

  def self.create_proxy_service
    DRbObject.new_with_uri(File.read uri_file).tap do |service|
      def service.stop
      end

      def service.start
      end
    end
  end

end