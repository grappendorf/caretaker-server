def real_mode?
	Rails.env.production?
end

Bool = Mongoid::Boolean
