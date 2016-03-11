# == Schema Information
#
# Table name: weather_widgets
#
#  id      :integer          not null, primary key
#

require 'models/widget_base'

class ActionWidget < ActiveRecord::Base
  inherit WidgetBase
  acts_as :widget

  belongs_to :device_action

  before_validation :set_default_title

  def self.attr_accessible
    Widget.attr_accessible
  end

  private

  def set_default_title
    self.title = 'Action' unless self.title.present?
  end
end
