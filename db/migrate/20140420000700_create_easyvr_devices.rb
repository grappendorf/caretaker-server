class CreateEasyvrDevices < ActiveRecord::Migration

	def change
		create_table :easyvr_devices do |t|
			t.integer :num_buttons
			t.integer :buttons_per_row
		end
	end

end
