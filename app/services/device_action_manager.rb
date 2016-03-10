class DeviceActionManager
  def initialize
    @actions_by_id = {}
  end

  def start
    Grape::API.logger.info 'Device Action Manager starting'
    DeviceAction.all.each do |action|
      instantiate_action_module action
    end
  end

  def stop
    Grape::API.logger.info 'Device Action Manager stopping'
  end

  def update_action action
    begin
      instantiate_action_module action
    rescue Exception => x
      Grape::API.logger.error %Q[#{x.message}\n\t#{x.backtrace.join "\n\t"}]
    end
  end

  def remove_action action
    @actions_by_id.delete action.id
  end

  def execute_action action
    begin
      @actions_by_id[action.id].execute
    rescue Exception => x
      Grape::API.logger.error %Q[#{x.message}\n\t#{x.backtrace.join "\n\t"}]
    end
  end

  private

  def instantiate_action_module action
    action_module_name = "DeviceAction_#{action.name.gsub /\W+/, '_'}"
    Grape::API.logger.debug "Instantiating action module #{action_module_name}"
    code = <<-CODE
			module #{action_module_name}
        def self.execute
    #{action.script}
        end
			end
      #{action_module_name}
    CODE
    begin
      action_instance = eval code
      @actions_by_id[action.id] = action_instance
    rescue Exception => x
      Grape::API.logger.error %Q[#{x.message}\n\t#{x.backtrace.join "\n\t"}]
    end
  end
end
