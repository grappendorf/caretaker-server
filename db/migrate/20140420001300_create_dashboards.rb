class CreateDashboards < ActiveRecord::Migration

  def change
    create_table :dashboards do |t|
      t.string :name
      t.boolean :default
      t.references :user
    end
  end

end
