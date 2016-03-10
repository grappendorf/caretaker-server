# == Schema Information
#
# Table name: roles
#
#  id            :integer          not null, primary key
#  name          :string
#  resource_id   :integer
#  resource_type :string
#

class Role < ActiveRecord::Base
  has_and_belongs_to_many :users
  belongs_to :resource, :polymorphic => true

  require "rolify/adapters/#{Rolify.orm}/scopes.rb"
  extend Rolify::Adapter::Scopes
end
