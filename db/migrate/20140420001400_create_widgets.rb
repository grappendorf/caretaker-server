class CreateWidgets < ActiveRecord::Migration

  def change
    create_table :widgets do |t|
      t.actable
      t.integer :x, default: 1
      t.integer :y, default: 1
      t.integer :width, default: 1
      t.integer :height, default: 1
      t.string :title
      t.references :dashboard
    end
  end

end
