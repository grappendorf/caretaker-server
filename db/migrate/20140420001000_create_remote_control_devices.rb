class CreateRemoteControlDevices < ActiveRecord::Migration
  def change
    create_table :remote_control_devices do |t|
      t.integer :num_buttons
      t.integer :buttons_per_row
    end
  end
end
