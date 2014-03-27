class Device

	include Mongoid::Document

	field :name, type: String
	field :address, type: String
	field :description, type: String

	validates :name, presence: true, uniqueness: true
	validates :address, presence: true

	index({name: 1}, {unique: true})

	def self.attr_accessible
		[:name, :address, :description]
	end

	scope :search, -> (q) { any_of({name: /#{q}/i}, {address: /#{q}/i}, {description: /#{q}/i}) }
	scope :search_names, -> (q) { where({name: /#{q}/i}) }

	def self.handle_connection_state_with connection_state_handler
		include ConnectionState
		include connection_state_handler
	end

	def self.small_icon()
		'16/processor.png'
	end

	def self.large_icon()
		'32/processor.png'
	end

	def self.models
		Device.subclasses
	end

	def self.models_paths
		self.models.map { |m| m.model_name.plural }
	end

	def change_listeners
		@change_listeners ||= []
	end

	def when_changed &block
		change_listeners << block
	end

	def notify_change_listeners
		change_listeners.each { |l| l.call self }
	end

	def update
	end

	def start
		connect
	end

	def stop
		disconnect
	end

	def reset
		disconnect
		connect
	end

	def current_state
	end

	def put_state params
	end

end