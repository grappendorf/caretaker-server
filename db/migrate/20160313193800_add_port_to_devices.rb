class AddPortToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :port, :integer, default: Application.config.device_port
  end
end
