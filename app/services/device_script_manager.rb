class DeviceScriptManager
  def initialize
    @scripts_by_id = {}
  end

  def start
    Grape::API.logger.info 'Device Script Manager starting'
    DeviceScript.all.each do |script|
      if script.enabled?
        instantiate_script_class script
      end
    end
  end

  def stop
    Grape::API.logger.info 'Device Script Manager stopping'
  end

  def update_script script
    begin
      script_instance = @scripts_by_id[script.id]

      if script_instance && script_instance.respond_to?(:stop)
        script_instance.stop
      end

      if script.enabled?
        instantiate_script_class script
      elsif script_instance
        @scripts_by_id.delete script.id
      end
    rescue Exception => x
      Grape::API.logger.error %Q[#{x.message}\n\t#{x.backtrace.join "\n\t"}]
    end
  end

  def remove_script script
    begin
      script_instance = @scripts_by_id[script.id]
      if script_instance && script_instance.respond_to?(:stop)
        script_instance.stop
      end
      @scripts_by_id.delete script.id
    rescue Exception => x
      Grape::API.logger.error %Q[#{x.message}\n\t#{x.backtrace.join "\n\t"}]
    end
  end

  private
  def instantiate_script_class script
    script_class_name = "DeviceScript_#{script.name.gsub /\W+/, '_'}"
    Grape::API.logger.debug "Instantiating script class #{script_class_name}"
    code = <<-CODE
			class #{script_class_name}
    #{script.script}
			end
			#{script_class_name}.new
    CODE
    begin
      script_instance = eval code
      @scripts_by_id[script.id] = script_instance
      script_instance.start if script_instance.respond_to? :start
    rescue Exception => x
      Grape::API.logger.error %Q[#{x.message}\n\t#{x.backtrace.join "\n\t"}]
    end
  end
end
