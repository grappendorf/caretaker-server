ActiveSupport.on_load(:active_model_serializers) do
	# Disable for all serializers (except ArraySerializer)
	ActiveModel::Serializer.root = false

	# Disable for ArraySerializer
	ActiveModel::ArraySerializer.root = false
end

class BSON::ObjectId
	def as_json *args
		to_s
	end
end
