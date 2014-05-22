class CreateRooms < ActiveRecord::Migration

	def change
		create_table :rooms do |t|
			t.string :number
			t.string :description
			t.references :floor
		end

		add_index :rooms, :number
	end

end
