class Floor

	include Mongoid::Document

	field :name, type: String
	field :description, type: String

	belongs_to :building

	has_many :rooms, dependent: :destroy

	validates :name, presence: true

	scope :search, -> (q) { where name: /#{q}/ }

	scope :in_building, -> (building) { where building: building }

end
