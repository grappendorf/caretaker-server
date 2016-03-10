class CreateDeviceWidgets < ActiveRecord::Migration
  def change
    create_table :device_widgets do |t|
      t.references :device, polymorphic: true
    end
  end
end
