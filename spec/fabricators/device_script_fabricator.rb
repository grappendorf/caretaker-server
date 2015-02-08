# == Schema Information
#
# Table name: device_scripts
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  script      :text
#  enabled     :boolean
#

Fabricator :device_script do
  name { sequence(:name) { |n| "Script-#{n}" } }
  description { sequence(:description) { |n| Faker::Lorem.sentence } }
  script '10.times { puts "Hello!" }'
  enabled true
end
