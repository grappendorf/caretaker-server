class CreateDeviceActions < ActiveRecord::Migration
  def change
    create_table :device_actions do |t|
      t.string :name
      t.string :description
      t.text :script
    end
  end
end
