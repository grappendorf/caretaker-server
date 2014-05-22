class CreateFloors < ActiveRecord::Migration

	def change
		create_table :floors do |t|
			t.string :name
			t.string :description
			t.references :building
		end

		add_index :floors, :name
	end

end
