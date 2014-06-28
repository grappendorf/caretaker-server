json.array! @dashboards do |dashboard|
	json.id dashboard.id
	json.name dashboard.name
	json.default dashboard.default
end