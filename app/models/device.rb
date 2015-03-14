# == Schema Information
#
# Table name: devices
#
#  id           :integer          not null, primary key
#  actable_id   :integer
#  actable_type :string
#  name         :string
#  address      :string
#  description  :string
#  uuid         :string
#

class Device < ActiveRecord::Base

  actable

  inherit DeviceBase

  validates :uuid, presence: true, uniqueness: true
  validates :name, presence: true, uniqueness: true
  validates :address, presence: true

  scope :search, -> (q) { where('name like ? or address like ? or description like ?', "%#{q}%", "%#{q}%", "%#{q}%") }

  scope :search_names, -> (q) { where('name like ?', "%#{q}%") }

  def self.new_from_type type
    klass = type.to_s.singularize.camelcase.constantize
    unless klass.ancestors.include? DeviceBase::InstanceMethods
      raise ArgumentError
    end
    klass.new
  end

end
