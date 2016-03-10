class CreateSensorDevices < ActiveRecord::Migration
  def change
    create_table :sensor_devices do |t|
      t.text :sensors
    end
  end
end
