# == Schema Information
#
# Table name: widgets
#
#  id           :integer          not null, primary key
#  actable_id   :integer
#  actable_type :string
#  width        :integer          default(1)
#  height       :integer          default(1)
#  title        :string
#  dashboard_id :integer
#  position     :integer
#

Fabricator :widget do
end

Fabricator :clock_widget do
end

Fabricator :device_widget do
  position 0
  width 1
  height 1
  device { Fabricate :switch_device }
end
