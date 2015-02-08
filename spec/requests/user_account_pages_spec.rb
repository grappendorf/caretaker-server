require 'spec_helper'

describe 'user account pages' do

  # subject { page }
  #
  # let!(:user) { Fabricate :user }
  # let!(:other_user) { Fabricate :other_user }
  #
  # before { sign_in user }
  #
  # describe 'show' do
  #
  # 	context 'the users own profile' do
  # 		before { visit user_path user }
  #
  # 		it { should have_content user.name }
  # 		it { should have_content user.email }
  # 		it { should have_link '', href: edit_user_path(user) }
  # 	end
  #
  # 	context 'another users profile' do
  # 		before { visit user_path other_user }
  #
  # 		it { should show_an_authorization_error }
  # 	end
  # end
  #
  # describe 'edit' do
  #
  # 	context 'the users own profile' do
  #
  # 		before { visit edit_user_path user, myself: :profile }
  #
  # 		describe 'form' do
  # 			it { should have_field 'Name' }
  # 			it { should have_field 'Email' }
  # 			it { should_not have_field 'user[password]' }
  # 			it { should_not have_field 'user[password_confirmation]' }
  # 			it { should have_button 'Save' }
  # 			it { should have_link 'Cancel' }
  # 		end
  #
  # 		describe 'with invalid information' do
  #
  # 			let(:old_name) { user.name }
  #
  # 			before do
  # 				fill_in 'Name', with: ''
  # 				click_button 'Save'
  # 			end
  #
  # 			it { should have_selector '.alert-error' }
  # 			it { should have_field 'user[name]', with: '' }
  # 			specify { user.reload.name.should == old_name }
  #
  # 		end
  #
  # 		describe 'with valid information' do
  #
  # 			let(:new_name) { 'new_user_name' }
  # 			let(:new_email) { 'new_user_name@example.com' }
  #
  # 			before do
  # 				fill_in 'Name', with: new_name
  # 				fill_in 'Email', with: new_email
  # 				click_button 'Save'
  # 			end
  #
  # 			it { should have_selector '.alert-success' }
  # 			it { should have_content new_email }
  # 			it { should_not have_link 'Sign in' }
  # 			specify { user.reload.name.should == new_name }
  # 			specify { user.reload.email.should == new_email }
  #
  # 		end
  #
  # 	end
  #
  # 	context 'another users profile' do
  # 		before { visit edit_user_path other_user, myself: :profile }
  #
  # 		it { should show_an_authorization_error }
  # 	end
  #
  # end
  #
  # describe 'change the password' do
  #
  # 	context 'of the user' do
  #
  # 		before { visit edit_user_path user, myself: :password }
  #
  # 		describe 'password form' do
  # 			it { should have_field 'user[password]' }
  # 			it { should have_field 'user[password_confirmation]' }
  # 		end
  #
  # 		describe 'with valid information' do
  #
  # 			let(:new_password) { 'new_password' }
  #
  # 			before do
  # 				fill_in 'user_password', with: new_password
  # 				fill_in 'user_password_confirmation', with: new_password
  # 				click_button 'Change password'
  # 			end
  #
  # 			it { should have_selector '.alert-success' }
  # 			it 'changes the password' do
  # 				visit destroy_user_session_path
  # 				sign_in user, password: new_password
  # 				should have_link 'Sign out', href: destroy_user_session_path
  # 			end
  # 		end
  #
  # 		describe 'with invalid information' do
  #
  # 			before do
  # 				fill_in 'user_password', with: 'abcdefgh'
  # 				fill_in 'user_password_confirmation', with: 'ijklmnop'
  # 				click_button 'Change password'
  # 			end
  # 			it { should have_selector '.alert-error' }
  # 			it 'does not change the password' do
  # 				visit destroy_user_session_path
  # 				sign_in user
  # 				should have_link 'Sign out', href: destroy_user_session_path
  # 			end
  #
  # 		end
  #
  # 		describe 'with empty password' do
  #
  # 			before do
  # 				fill_in 'user_password', with: ''
  # 				fill_in 'user_password_confirmation', with: ''
  # 				click_button 'Change password'
  # 			end
  # 			it { should have_selector '.alert-error' }
  # 			it 'does not change the password' do
  # 				visit destroy_user_session_path
  # 				sign_in user
  # 				should have_link 'Sign out', href: destroy_user_session_path
  # 			end
  #
  # 		end
  #
  # 	end
  #
  # 	context 'of another user' do
  # 		before { visit edit_user_path other_user, myself: :password }
  #
  # 		it { should show_an_authorization_error }
  # 	end
  #
  # end

end
