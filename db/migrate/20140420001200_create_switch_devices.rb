class CreateSwitchDevices < ActiveRecord::Migration
  def change
    create_table :switch_devices do |t|
      t.integer :num_switches
      t.integer :switches_per_row
    end
  end
end
