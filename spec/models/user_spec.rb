# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string
#  email                  :string           default("")
#  encrypted_password     :string           default("")
#  reset_password_token   :string
#  reset_password_sent_at :time
#  remember_created_at    :time
#  sign_in_count          :integer          default("0")
#  current_sign_in_at     :time
#  last_sign_in_at        :time
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#

require 'spec_helper'

describe User do

  subject(:user) { Fabricate :user }

  let(:other_user) { Fabricate :other_user }

  it { should respond_to :name }
  it { should respond_to :email }
  it { should respond_to :password }
  it { should respond_to :password_confirmation }
  it { should respond_to :roles }
  it { should respond_to :dashboards }
  it { should be_valid }

  describe 'is invalid if it' do

    it 'has an empty name' do
      user.name = ''
      should_not be_valid
    end

    it 'has an empty email' do
      user.email = ''
      should_not be_valid
    end

    it 'has a malformed email format' do
      wrong_emails = %w[bob@foo,net chuck, dude@bar. .]
      wrong_emails.each do |wrong_email|
        user.email = wrong_email
        should_not be_valid
      end
    end

    it 'has the same name as another user' do
      user.name = other_user.name
      should_not be_valid
    end

    it 'has the same email as another user (case insensitive)' do
      user.email = other_user.email.upcase
      should_not be_valid
    end

    it 'has an empty password' do
      user.password = user.password_confirmation = ''
      should_not be_valid
    end

    it 'has a password that is too short' do
      user.password = user.password_confirmation = '123'
      should_not be_valid
    end

    it 'has a password that does not match the confirmation' do
      user.password_confirmation = 'unmatched_confirmation'
      should_not be_valid
    end

  end

  describe 'when saved' do

    describe 'converts the email address to lowercase' do
      before do
        user.email = 'User@Example.COM'
        user.save
      end
      its(:email) { should == 'user@example.com' }
    end

  end

  describe 'dashboards' do
    before do
      user.dashboards << Fabricate(:dashboard, default: true)
      user.dashboards << Fabricate(:dashboard)
    end

    it 'has a default dashboard' do
      user.dashboards.default.should == Dashboard.first
    end
  end

end
