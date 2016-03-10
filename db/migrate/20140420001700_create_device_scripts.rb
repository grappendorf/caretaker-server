class CreateDeviceScripts < ActiveRecord::Migration
  def change
    create_table :device_scripts do |t|
      t.string :name
      t.string :description
      t.text :script
      t.boolean :enabled
    end
  end
end
