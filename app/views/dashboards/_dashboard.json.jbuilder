json.id dashboard.id
json.name dashboard.name
json.default dashboard.default
unless defined? without_widgets
	json.widgets do
		json.partial! "widgets/widget", collection: dashboard.widgets.map(&:specific), as: :widget
	end
end
