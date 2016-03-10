# == Schema Information
#
# Table name: users
#
#  id                 :integer          not null, primary key
#  name               :string
#  email              :string           default("")
#  encrypted_password :string           default("")
#

require 'spec_helper'

describe User do
  subject(:user) { Fabricate :user }

  let(:other_user) { Fabricate :other_user }

  it { is_expected.to respond_to :name }
  it { is_expected.to respond_to :email }
  it { is_expected.to respond_to :password }
  it { is_expected.to respond_to :encrypted_password }
  it { is_expected.to respond_to :roles }
  it { is_expected.to respond_to :dashboards }
  it { is_expected.to be_valid }

  describe 'is invalid if it' do
    it 'has an empty name' do
      user.name = ''
      is_expected.not_to be_valid
    end

    it 'has an empty email' do
      user.email = ''
      is_expected.not_to be_valid
    end

    it 'has a malformed email format' do
      wrong_emails = %w[bob@foo,net chuck, dude@bar. .]
      wrong_emails.each do |wrong_email|
        user.email = wrong_email
        is_expected.not_to be_valid
      end
    end

    it 'has the same name as another user' do
      user.name = other_user.name
      is_expected.not_to be_valid
    end

    it 'has the same email as another user (case insensitive)' do
      user.email = other_user.email.upcase
      is_expected.not_to be_valid
    end

    it 'has a password that is too short' do
      user.password = '123'
      is_expected.not_to be_valid
    end
  end

  describe 'when created' do
    let (:user) { Fabricate.build :user, password: '' }
    describe 'and no password is set' do
      it 'should not save the user' do
        expect(user.save).to be_falsey
      end
    end
  end

  describe 'when saved' do
    describe 'converts the email address to lowercase' do
      before do
        user.email = 'User@Example.COM'
        user.save
      end
      its(:email) { is_expected.to eq('user@example.com') }
    end

    describe 'when no password is set' do
      before do
        user.password = ''
      end
      it 'should not change the password' do
        expect { user.save! }.not_to change { user.reload.encrypted_password }
      end
    end
  end

  describe 'dashboards' do
    before do
      user.dashboards << Fabricate(:dashboard, default: true)
      user.dashboards << Fabricate(:dashboard)
    end

    it 'has a default dashboard' do
      expect(user.dashboards.default).to eq Dashboard.first
    end
  end
end
