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

require 'spec_helper'

describe Widget do

  subject(:widget) { Fabricate.build :widget }

  it { should respond_to :dashboard }
  it { should respond_to :title }
  it { should respond_to :width }
  it { should respond_to :height }
  it { should respond_to :position }

end
