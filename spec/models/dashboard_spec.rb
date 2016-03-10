# == Schema Information
#
# Table name: dashboards
#
#  id      :integer          not null, primary key
#  name    :string
#  default :boolean
#  user_id :integer
#

require 'spec_helper'

describe Dashboard do
  subject(:dashboard) { Fabricate.build :dashboard }

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :default }
  it { is_expected.to respond_to :user }
  it { is_expected.to respond_to :widgets }

  describe 'is invalid if' do
    it 'has an empty name' do
      subject.name = ''
      is_expected.not_to be_valid
    end
  end
end
