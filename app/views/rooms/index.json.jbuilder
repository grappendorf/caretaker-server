json.array! @rooms do |room|
	json.id room.id
	json.number room.number
	json.description room.description
end