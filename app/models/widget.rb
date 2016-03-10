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

class Widget < ActiveRecord::Base
  inherit WidgetBase
  actable

  belongs_to :dashboard

  validates :position, numericality: { greater_than_or_equal_to: 0 }, allow_blank: true

  default_scope { order 'position' }

  before_create :calculate_next_position

  def type
    specific.class.name
  end

  def self.new_from_type type
    klass = type.to_s.singularize.camelcase.constantize
    unless klass.ancestors.include? WidgetBase::InstanceMethods
      raise ArgumentError
    end
    klass.new
  end

  private

  def calculate_next_position
    self.position = (self.dashboard.widgets.maximum(:position) || 0) + 1
  end
end
