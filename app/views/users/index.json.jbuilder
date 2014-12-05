json.array! @users do |user|
	json.id user.id
	json.email user.email
	json.name user.name
	json.roles user.roles.map(&:name)
	json.last_sign_in_at user.last_sign_in_at
end
