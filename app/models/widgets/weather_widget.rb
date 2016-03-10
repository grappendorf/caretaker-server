# == Schema Information
#
# Table name: weather_widgets
#
#  id      :integer          not null, primary key
#  api_key :string
#

require 'models/widget_base'

class WeatherWidget < ActiveRecord::Base

  inherit WidgetBase

  acts_as :widget

  before_validation :set_default_title

  def self.attr_accessible
    Widget.attr_accessible
  end

  private

  def set_default_title
    self.title = 'Weather' unless self.title.present?
  end
end
