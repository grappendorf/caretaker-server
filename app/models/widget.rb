# == Schema Information
#
# Table name: widgets
#
#  id             :integer          not null, primary key
#  as_widget_id   :integer
#  as_widget_type :string(255)
#  x              :integer          default(1)
#  y              :integer          default(1)
#  width          :integer          default(1)
#  height         :integer          default(1)
#  title          :string(255)
#  dashboard_id   :integer
#

class Widget < ActiveRecord::Base

	is_a_superclass

	belongs_to :dashboard

	inherit WidgetBase
end
