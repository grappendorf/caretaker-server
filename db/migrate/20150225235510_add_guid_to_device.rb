class AddGuidToDevice < ActiveRecord::Migration
  def change
    add_column :devices, :guid, :string
  end
end
