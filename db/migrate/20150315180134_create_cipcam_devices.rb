class CreateCipcamDevices < ActiveRecord::Migration

  def change
    create_table :cipcam_devices do |t|
      t.string :user
      t.string :password
      t.string :refresh_interval
    end
  end

end
