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

require 'spec_helper'

describe Widget do
  subject(:widget) { Fabricate.build :widget }

  it { is_expected.to respond_to :dashboard }
  it { is_expected.to respond_to :title }
  it { is_expected.to respond_to :width }
  it { is_expected.to respond_to :height }
  it { is_expected.to respond_to :position }
end
