# == Schema Information
#
# Table name: device_actions
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  script      :text
#

class DeviceAction < ActiveRecord::Base

  validates :name, presence: true, uniqueness: true

  scope :search, -> (q) { where('name like ? or description like ?', "%#{q}%", "%#{q}%") }

end
