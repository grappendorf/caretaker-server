class Dashboard

	include Mongoid::Document

	field :name, type: String
	field :default, type: Bool

	belongs_to :user

	has_many :widgets, dependent: :destroy

	validates :name, presence: true

	def self.attr_accessible
    [:name, :default]
  end

  scope :search, -> (q) { User.and(:$or => [{name: /#{q}/i}]) }

	scope :search_names, -> (q) { where({name: /#{q}/i}) }

end
