require 'spec_helper'

describe 'User pages' do

  subject { page }

  let!(:admin) { Fabricate :admin }
  let!(:user) { Fabricate :user }
  let!(:other_user) { Fabricate :other_user }

  before { sign_in admin }

  describe 'Index' do

    describe 'page' do

      before do
        visit users_path
      end

      it { should have_selector 'th', text: 'Name' }
      it { should have_selector 'th', text: 'Roles' }
      it { should have_selector 'th', text: 'Email' }
      it { should have_selector 'td', text: user.name }
      it { should have_selector 'td', text: user.roles.map(&:name).join(', ') }
      it { should have_selector 'td', text: user.email }
      it { should have_link '', href: edit_user_path(user) }
    end

  end

  describe 'show' do

    before { visit user_path user }

    it { should have_content user.name }
    it { should have_content user.email }
    it { should have_link '', href: edit_user_path(user) }

  end

  describe 'edit' do

    before { visit edit_user_path user }

    describe 'page' do
      it { should have_field 'Name' }
      it { should have_field 'Email' }
      it { should have_field 'user[password]' }
      it { should have_field 'user[password_confirmation]' }
      it { should have_button 'Save' }
      it { should have_link 'Cancel' }
    end

    describe 'with invalid information' do

      let(:old_name) { user.name }

      before do
        fill_in 'Name', with: ''
        click_button 'Save'
      end

      it { should have_selector '.alert-error' }
      it { should have_field 'user[name]', with: '' }
      specify { user.reload.name.should == old_name }

    end

    describe 'with valid information' do

      let(:new_name) { 'new_user_name' }
      let(:new_email) { 'new_user_name@example.com' }
      let(:new_password) { 'new_password' }

      before do
        fill_in 'Name', with: new_name
        fill_in 'Email', with: new_email
        fill_in 'user_password', with: new_password
        fill_in 'user_password_confirmation', with: new_password
        click_button 'Save'
      end

      it { should have_selector '.alert-success' }
      it { should have_content new_name }
      it { should have_content new_email }
      specify { user.reload.name.should == new_name }
      specify { user.reload.email.should == new_email }

    end

  end

end
