# == Schema Information
#
# Table name: rooms
#
#  id          :integer          not null, primary key
#  number      :string(255)
#  description :string(255)
#  floor_id    :integer
#

Fabricator :room do
  number { sequence(:number) { |n| "Room-#{n}" } }
  description { sequence(:description) { |n| "This is room #{n}" } }
  floor { Floor.first || Fabricate(:floor) }
end
