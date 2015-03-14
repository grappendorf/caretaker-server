# == Schema Information
#
# Table name: dashboards
#
#  id      :integer          not null, primary key
#  name    :string
#  default :boolean
#  user_id :integer
#

class Dashboard < ActiveRecord::Base

  belongs_to :user

  has_many :widgets, dependent: :destroy

  validates :name, presence: true

  scope :search, -> (q) { where('name like ?', "%#{q}%") }

  scope :search_names, -> (q) { where('name like ?', "%#{q}%") }

end
