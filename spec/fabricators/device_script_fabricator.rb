# == Schema Information
#
# Table name: device_scripts
#
#  id          :integer          not null, primary key
#  name        :string
#  description :string
#  script      :text
#  enabled     :boolean
#

Fabricator :device_script do
  name { sequence(:name) { |n| "Script-#{n}" } }
  description { sequence(:description) { |_n| Faker::Lorem.sentence } }
  script 'ans = 42'
  enabled true
end
