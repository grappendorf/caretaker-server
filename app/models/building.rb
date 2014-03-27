class Building

	include Mongoid::Document

	field :name, type: String
	field :description, type: String

	has_many :floors, dependent: :destroy

	validates :name, presence: true, uniqueness: true

	scope :search, -> (q) { any_of({name: /#{q}/i}, {description: /#{q}/i}) }

end
