# == Schema Information
#
# Table name: ip_camera_devices
#
#  id               :integer          not null, primary key
#  host             :string
#  port             :integer
#  user             :string
#  password         :string
#  refresh_interval :string
#

require 'spec_helper'
require 'models/device_shared_examples'

describe IpCameraDevice do

  subject(:ip_camera_device) { Fabricate :ip_camera_device }

  it_behaves_like 'a device'

  it { should respond_to :host }
  it { should respond_to :port }
  it { should respond_to :user }
  it { should respond_to :password }
  it { should respond_to :refresh_interval }

  describe 'is invalid if' do

    it 'has an empty host' do
      subject.host = ''
      should_not be_valid
    end

    it 'has an invalid port' do
      subject.port = 0
      should_not be_valid
    end

    it 'has an invalid refresh interval' do
      subject.refresh_interval = 0
      should_not be_valid
    end

  end

end
