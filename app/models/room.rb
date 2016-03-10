# == Schema Information
#
# Table name: rooms
#
#  id          :integer          not null, primary key
#  number      :string
#  description :string
#  floor_id    :integer
#

class Room < ActiveRecord::Base
  belongs_to :floor
  has_many :devices

  validates :number, presence: true

  scope :search, -> (q) { where('number like ?', "%#{q}%") }
  scope :on_floor, -> (floor) { where floor_id: floor }
end
