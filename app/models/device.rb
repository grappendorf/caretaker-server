# == Schema Information
#
# Table name: devices
#
#  id             :integer          not null, primary key
#  as_device_id   :integer
#  as_device_type :string(255)
#  name           :string(255)
#  address        :string(255)
#  description    :string(255)
#  uuid           :string(255)
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
    unless klass.ancestors.include? ActiveRecord::ActsAsModules::ActsAsDevice
      raise ArgumentError
    end
    klass.new
  end

end
