# == Schema Information
#
# Table name: widgets
#
#  id           :integer          not null, primary key
#  actable_id   :integer
#  actable_type :string
#  width        :integer          default("1")
#  height       :integer          default("1")
#  title        :string
#  dashboard_id :integer
#  position     :integer
#

class Widget < ActiveRecord::Base

  actable

  belongs_to :dashboard

  inherit WidgetBase

  default_scope { order 'position' }

  def type
    specific.class.name
  end

end
