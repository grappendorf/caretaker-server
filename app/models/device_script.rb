class DeviceScript

	include Mongoid::Document

	field :name, type: String
	field :description, type: String
	field :script, type: String
	field :enabled, type: Bool

	validates :name, presence: true, uniqueness: true

  def self.attr_accessible
    [:name, :description, :script, :enabled]
  end

  scope :search, -> (q) { any_of({name: /#{q}/i}, {description: /#{q}/i}) }

end
