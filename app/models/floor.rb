# == Schema Information
#
# Table name: floors
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  building_id :integer
#

class Floor < ActiveRecord::Base
  belongs_to :building
  has_many :rooms, dependent: :destroy

  validates :name, presence: true

  scope :search, -> (q) { where('name like ?', "%#{q}%") }
  scope :in_building, -> (building) { where building_id: building }
end
