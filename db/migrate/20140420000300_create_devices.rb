class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.actable
      t.string :name
      t.string :address
      t.string :description
    end

    add_index :devices, :name, unique: true
  end
end
