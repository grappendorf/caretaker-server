module WidgetBase
	module ClassMethods
		def attr_accessible
			[:dashboard_id, :x, :y, :width, :height, :title]
		end

		def models
			WidgetBase.widget_models
		end

		def models_paths
			self.models.map { |m| m.model_name.plural }
		end
	end

	def self.widget_models
		@@widget_models ||= []
	end

	def self.inherited subclass
		widget_models << subclass unless subclass == Widget
	end

end