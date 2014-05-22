class CreateBuildings < ActiveRecord::Migration

	def change
		create_table :buildings do |t|
			t.string :name
			t.string :description
		end

		add_index :buildings, :name
	end

end
