# == Schema Information
#
# Table name: device_scripts
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  script      :text
#  enabled     :boolean
#

class DeviceScript < ActiveRecord::Base

	validates :name, presence: true, uniqueness: true

	scope :search, -> (q) { where('name like ? or description like ?', "%#{q}%", "%#{q}%") }

end
