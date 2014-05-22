class CreateUsers < ActiveRecord::Migration

	def change
		create_table :users do |t|
			t.string :name
			# Devise
			# Database authenticatable
			t.string :email, default: ''
			t.string :encrypted_password, default: ''
			# Recoverable
			t.string :reset_password_token
			t.time :reset_password_sent_at
			# Rememberable
			t.time :remember_created_at
			# Trackable
			t.integer :sign_in_count, :default => 0
			t.time :current_sign_in_at
			t.time :last_sign_in_at
			t.string :current_sign_in_ip
			t.string :last_sign_in_ip
			## Confirmable
			# t.string :confirmation_token
			# t.time :confirmed_at
			# t.time :confirmation_sent_at
			# t.string :unconfirmed_email # Only if using reconfirmable
			## Lockable
			# t.integer :failed_attempts, :default => 0 # Only if lock strategy is :failed_attempts
			# t.string :unlock_token # Only if unlock strategy is :email or :both
			# t.time :locked_at
			## Token authenticatable
			# t.string :authentication_token
		end

		add_index :users, :email
	end

end
