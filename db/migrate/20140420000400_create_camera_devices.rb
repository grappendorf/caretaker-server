class CreateCameraDevices < ActiveRecord::Migration

	def change
		create_table :camera_devices do |t|
			t.string :host
			t.integer :port
			t.string :user
			t.string :password
			t.string :refresh_interval
		end
	end

end
