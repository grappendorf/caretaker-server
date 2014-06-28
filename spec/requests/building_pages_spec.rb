require 'spec_helper'

describe 'Building pages' do

	subject { page }

	let(:user) { Fabricate :admin }

	before { sign_in user }

	describe 'Link to the buildings list' do
		before { visit root_path }
		it { should have_link 'Buildings', href: buildings_path }
	end

	describe 'Index' do

		describe 'page' do

			before do
				3.times do
					building = Fabricate :building
					Fabricate :floor, building: building
				end
				visit buildings_path
			end

			it { should have_title 'Buildings' }
			it { should have_link 'New', href: new_building_path }
			it { should have_selector 'th', text: 'Name' }
			it { should have_selector 'th', text: 'Description' }
			it 'should display all buildings with action links' do
				Building.all.each do |building|
					should have_selector 'td', text: building.name
					should have_selector 'td', text: building.description
					should have_link 'Edit', href: edit_building_path(building)
					should have_link 'Delete', href: building_path(building)
					should have_link 'Floors', href: building_floors_path(building)
				end
			end

			describe 'clicking on a floors link' do
				before { click_href building_floors_path(Building.first) }
				it { should have_text Floor.in_building(Building.first).first.name }
				it { should_not have_text Floor.in_building(Building.last).first.name }
			end
		end

	end

	describe 'New' do

		before { visit new_building_path }

		describe 'page' do
			it { should have_title 'Create Building' }
			it { should have_selector 'legend', text: 'Building' }
			it { should have_field 'Name' }
			it { should have_field 'Description' }
			it { should have_button 'Save' }
			it { should have_link 'Cancel' }
		end

		describe 'submit with valid data' do
			it 'should create a new building' do
				expect do
					fill_in 'Name', with: 'The new building'
					click_button 'Save'
				end.to change(Building, :count).by 1
			end

			it 'should redirect to the building list and show a success flash' do
				fill_in 'Name', with: 'The new building'
				click_button 'Save'
				current_path.should == buildings_path
				should have_selector '.alert-success'
			end
		end

		describe 'submit with invalid data' do
			it 'should not create a new building' do
				expect do
					click_button 'Save'
				end.not_to change(Building, :count)
			end

			it 'should stay on the edit page and show a flash error' do
				click_button 'Save'
				current_path.should == buildings_path
				should have_selector '.alert-error'
			end
		end

		describe 'cancel' do
			it 'should redirect to the buildings list' do
				click_link 'Cancel'
				current_path.should == buildings_path
			end
		end

	end

	describe 'Edit' do

		let!(:building) { Fabricate :building }

		before { visit edit_building_path building }

		describe 'page' do
			it { should have_title "Building #{building.name}" }
			it { should have_selector 'fieldset', text: "Building #{building.name}" }
			it { should have_field 'Name', with: building.name }
			it { should have_field 'Description', with: building.description }
			it { should have_button 'Save' }
			it { should have_link 'Cancel' }
		end

		describe 'submit with valid data' do

			let(:new_name) { 'New name' }
			let(:new_description) { 'New description' }

			before do
				fill_in 'Name', with: new_name
				fill_in 'Description', with: new_description
				click_button 'Save'
			end

			it { should have_selector '.alert-success' }
			it { should have_selector 'td', new_name }
			it { should have_selector 'td', new_description }
			specify { building.reload.name.should == new_name }
			specify { building.reload.description.should == new_description }
			specify { current_path.should == buildings_path }

		end

		describe 'submit with invalid data' do
			it 'should not update the building' do
				expect do
					fill_in 'Name', with: ''
					click_button 'Save'
				end.not_to change { building.reload.name }
			end

			it 'should stay on the edit page and show an error flash' do
				fill_in 'Name', with: ''
				click_button 'Save'
				current_path.should == building_path(building)
				should have_selector '.alert-error'
			end
		end

		describe 'cancel' do
			it 'should redirect to the buildings list' do
				click_link 'Cancel'
				current_path.should == buildings_path
			end
		end

	end

	describe 'Show' do

		let(:building) { Fabricate :building }

		before { visit building_path building }

		describe 'page' do
			it { should have_title "Building #{building.name}" }
			it { should have_selector 'fieldset[disabled]', text: "Building #{building.name}" }
			it { should have_link 'Back' }
			it { should_not have_button 'Save' }
		end

		describe 'back' do
			it 'should redirect to the buildings list' do
				click_link 'Back'
				current_path.should == buildings_path
			end
		end

	end

	describe 'Delete' do

		let!(:building) { Fabricate :building }

		it 'should delete the building' do
			expect do
				visit buildings_path
				click_link 'Delete', href: building_path(building)
			end.to change(Building, :count).by -1
		end

		it 'should redirect to the building list and show a flash success' do
			visit buildings_path
			click_link 'Delete', href: building_path(building)
			current_path.should == buildings_path
			should have_selector '.alert-success'
		end

	end

end
