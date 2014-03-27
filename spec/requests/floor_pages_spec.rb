require 'spec_helper'

describe 'Floor pages' do

	subject { page }

	let(:user) { FactoryGirl.create :admin }

	before { sign_in user }

	describe 'Link to the floors list' do
		before { visit root_path }
		it { should have_link 'Floors', href: floors_path }
	end

	describe 'Index' do

		describe 'page' do

			let(:building) { Building.first }

			before do
				3.times do
					floor = FactoryGirl.create :floor
					FactoryGirl.create :room, floor: floor
				end
			end

			context 'when called with a valid building id' do
				before { visit building_floors_path(building) }

				it { should have_title 'Floors' }
				it { should have_link 'New', href: new_building_floor_path(building) }
				it { should have_select 'building_id', with_options: Building.all.pluck(:name), selected: building.name }
				it { should have_selector 'th', text: 'Name' }
				it { should have_selector 'th', text: 'Description' }
				it 'should display all floors with action links' do
					Floor.all.each do |floor|
						should have_selector 'td', text: floor.name
						should have_selector 'td', text: floor.description
						should have_link 'Edit', href: edit_building_floor_path(floor.building, floor)
						should have_link 'Delete', href: building_floor_path(floor.building, floor)
						should have_link 'Rooms', href: building_floor_rooms_path(floor.building, floor)
					end
				end


				describe 'clicking on a rooms link' do
					before { click_href building_floor_rooms_path(Floor.first.building, Floor.first) }
					it { should have_text Room.on_floor(Floor.first).first.number }
					it { should_not have_text Room.on_floor(Floor.last).first.number }
				end

			end

			context 'when called without a building id' do
				before { visit floors_path }

				it { should have_text 'Please select a building' }
				it { should have_disabled_link 'New' }
				it { should have_select 'building_id', with_options: ['Select...'] + Building.all.pluck(:name) }
			end

		end

	end

	describe 'New' do

		context 'when called with a valid building id' do

			let(:building) { FactoryGirl.create :building }

			before { visit new_building_floor_path(building) }

			describe 'page' do
				it { should have_title "Create Floor" }
				it { should have_selector 'legend', text: "Floor" }
				it { should have_field 'Name' }
				it { should have_field 'Description' }
				it { should have_button 'Save' }
				it { should have_link 'Cancel' }
			end

			describe 'submit with valid data' do
				it 'should create a new floor' do
					expect do
						fill_in 'Name', with: 'The new floor'
						click_button 'Save'
					end.to change(Floor, :count).by 1
				end

				it 'should redirect to the floor list and show a flash success' do
					fill_in 'Name', with: 'The new floor'
					click_button 'Save'
					current_url.should == building_floors_url(building)
					should have_selector '.alert-success'
				end
			end

			describe 'submit with invalid data' do
				it 'should not create a new floor' do
					expect do
						click_button 'Save'
					end.not_to change(Floor, :count)
				end

				it 'should stay on the edit page and show a flash error' do
					click_button 'Save'
					current_path.should == building_floors_path(building)
					should have_selector '.alert-error'
				end
			end

		end

	end

	describe 'Edit' do

		let!(:floor) { FactoryGirl.create :floor }

		before { visit edit_building_floor_path(floor.building, floor) }

		describe 'page' do
			it { should have_title "Floor #{floor.name}" }
			it { should have_selector 'legend', text: 'Floor' }
			it { should have_field 'Name', with: floor.name }
			it { should have_field 'Description', with: floor.description }
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
			specify { floor.reload.name.should == new_name }
			specify { floor.reload.description.should == new_description }
			specify { current_url.should == building_floors_url(floor.building) }

		end

		describe 'submit with invalid data' do
			it 'should not update the floor' do
				expect do
					fill_in 'Name', with: ''
					click_button 'Save'
				end.not_to change { floor.reload.name }
			end

			it 'should stay on the edit page and show an error flash' do
				fill_in 'Name', with: ''
				click_button 'Save'
				current_path.should == building_floor_path(floor.building, floor)
				should have_selector '.alert-error'
			end
		end

		describe 'cancel' do
			it 'should redirect to the floors list' do
				click_link 'Cancel'
				current_url.should == building_floors_url(floor.building)
			end
		end

	end

	describe 'Show' do

		let(:floor) { FactoryGirl.create :floor }

		before { visit building_floor_path(floor.building, floor) }

		describe 'page' do
			it { should have_title "Floor #{floor.name}" }
			it { should have_selector 'fieldset[disabled]', text: "Floor #{floor.name}" }
			it { should have_link 'Back' }
			it { should_not have_button 'Save' }
		end

		describe 'back' do
			it 'should redirect to the floors list' do
				click_link 'Back'
				current_url.should == building_floors_url(floor.building)
			end
		end

	end

	describe 'Delete' do

		let!(:floor) { FactoryGirl.create :floor }

		it 'should delete the floor' do
			expect do
				visit building_floors_path(floor.building)
				click_link 'Delete', href: building_floor_path(floor.building, floor)
			end.to change(Floor, :count).by -1
		end

		it 'should redirect to the floor list and show a flash success' do
			visit building_floors_path(floor.building)
			click_link 'Delete', href: building_floor_path(floor.building, floor)
			should have_selector '.alert-success'
			current_url.should == building_floors_url(floor.building)
		end

	end

end
