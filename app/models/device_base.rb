require 'ostruct'

module DeviceBase
  module ClassMethods
    def attr_accessible
      [:uuid, :name, :address, :description]
    end

    def small_icon()
      '16/processor.png'
    end

    def large_icon()
      '32/processor.png'
    end

    def models
      DeviceBase.device_models
    end

    def models_paths
      self.models.map { |m| m.model_name.plural }
    end
  end

  module InstanceMethods
    def change_listeners
      @change_listeners ||= []
    end

    def when_changed &block
      @device_base_uuidgen ||= UUID.new
      listener = OpenStruct.new id: @device_base_uuidgen.generate, handler: block
      change_listeners << listener
      listener.id
    end

    def notify_change_listeners
      change_listeners.each { |l| l.handler.call self }
    end

    def remove_change_listener id
      change_listeners.delete_if { |l| l.id == id }
    end

    def update
    end

    def start
      connect
    end

    def stop
      disconnect
    end

    def reset
      disconnect
      connect
    end

    def current_state
    end

    def put_state params
    end
  end

  def self.device_models
    @@device_models ||= []
  end

  def self.inherited subclass
    device_models << subclass unless subclass == Device
  end

end