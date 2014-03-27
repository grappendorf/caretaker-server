class Room

	include Mongoid::Document

	field :number, type: String
	field :description, type: String

	belongs_to :floor

	has_many :devices, dependent: :destroy

	validates :number, presence: true

	index({number: 1}, {unique: true})

	scope :search, -> (q) { where number: /#{q}/ }

	scope :on_floor, -> (floor) { where floor: floor }

end
