# == Schema Information
#
# Table name: dashboards
#
#  id      :integer          not null, primary key
#  name    :string(255)
#  default :boolean
#  user_id :integer
#

class Dashboard < ActiveRecord::Base

	belongs_to :user

	has_many :widgets, dependent: :destroy

	validates :name, presence: true

	def self.attr_accessible
    [:name, :default]
  end

  scope :search, -> (q) { where('name like ?', "%#{q}%") }

	scope :search_names, -> (q) { where('name like ?', "%#{q}%") }

end
