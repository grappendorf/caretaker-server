# == Schema Information
#
# Table name: device_actions
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  script      :text
#

Fabricator :device_action do
  name { sequence(:name) { |n| "Action-#{n}" } }
  description { sequence(:description) { |_n| Faker::Lorem.sentence } }
  script 'ans = 42'
end
