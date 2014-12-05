json.id dashboard.id
json.name dashboard.name
json.default dashboard.default
json.user do
	json.id dashboard.user.id
	json.name dashboard.user.name
end
unless defined? without_widgets
	json.widgets do
		json.partial! "widgets/widget", collection: dashboard.widgets.map(&:specific), as: :widget
	end
end
