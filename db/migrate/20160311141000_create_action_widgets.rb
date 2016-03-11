class CreateActionWidgets < ActiveRecord::Migration
  def change
    create_table :action_widgets do |t|
      t.references :device_action
    end
  end
end
