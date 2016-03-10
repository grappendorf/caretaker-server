# == Schema Information
#
# Table name: buildings
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#

class Building < ActiveRecord::Base
  has_many :floors, dependent: :destroy

  validates :name, presence: true, uniqueness: true

  scope :search, -> (q) { where('name like ? or description like ?', "%#{q}%", "%#{q}%") }
end
