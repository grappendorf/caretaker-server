require 'spec_helper'

describe 'Room pages' do

	subject { page }

	let(:user) { Fabricate :admin }

	before { sign_in user }

	describe 'Link to the rooms list' do
		before { visit root_path }
		it { should have_link 'Rooms', href: rooms_path }
	end

	describe 'Index' do

		describe 'page' do

			let(:building) { Fabricate :building }
			let(:other_building) { Fabricate :building }
			let(:floor) { Fabricate :floor, building: building }
			let(:other_floor) { Fabricate :floor, building: other_building }

			before do
				Fabricate.times 3, :room, floor: floor
				Fabricate :room, floor: other_floor
			end

			context 'when called with a valid floor id' do
				before { visit building_floor_rooms_path(floor.building, floor) }

				it { should have_title 'Rooms' }
				it { should have_link 'New', href: new_building_floor_room_path(floor.building, floor) }
				it { should have_select 'building_id', with_options: Building.all.pluck(:name), selected: floor.building.name }
				it { should have_select 'floor_id', with_options: Floor.in_building(building).pluck(:name), selected: floor.name }
				it { should have_selector 'th', text: 'Number' }
				it { should have_selector 'th', text: 'Description' }
				it 'should display all rooms with action links' do
					Room.on_floor(floor).each do |room|
						should have_selector 'td', text: room.number
						should have_selector 'td', text: room.description
						should have_link 'Edit', href: edit_building_floor_room_path(floor.building, floor, room)
						should have_link 'Delete', href: building_floor_room_path(floor.building, floor, room)
					end
				end
				it 'should not display rooms of other floors' do
					should_not have_selector 'td', text: Room.on_floor(other_floor).first.number
				end
			end

			context 'when called with a building and a floor id that do not match' do
				before { visit rooms_path building_id: other_building, floor_id: floor }

				it { should have_text 'Please select a floor' }
				it { should have_select 'floor_id', with_options: Floor.in_building(other_building).pluck(:name) }
				it { should_not have_select 'floor_id', with_options: Floor.in_building(floor.building).pluck(:name) }
			end

			context 'when called without a floor id' do

				context 'and without a building id' do
					before { visit rooms_path }

					it { should have_text 'Please select a floor' }
					it { should have_disabled_link 'New' }
					it { should have_select 'building_id', with_options: ['Select...'] + Building.all.pluck(:name) }
					it { should have_select 'floor_id', with_options: ['Select...'] }
				end

				context 'but with a valid building id' do
					before { visit rooms_path building_id: building }

					it { should have_text 'Please select a floor' }
					it { should have_disabled_link 'New' }
					it { should have_select 'building_id', with_options: Building.all.pluck(:name), selected: floor.building.name }
					it { should have_select 'floor_id', with_options: ['Select...'] + Floor.in_building(building).pluck(:name) }
				end

			end

		end

	end

	describe 'New' do

		context 'when called with a valid floor id' do

			let(:floor) { Fabricate :floor }

			before { visit new_building_floor_room_path(floor.building, floor) }

			describe 'page' do
				it { should have_title "Create Room" }
				it { should have_selector 'legend', text: "Room" }
				it { should have_field 'Number' }
				it { should have_field 'Description' }
				it { should have_button 'Save' }
				it { should have_link 'Cancel' }
			end

			describe 'submit with valid data' do

				it 'should create a new room' do
					expect do
						fill_in 'Number', with: '999'
						click_button 'Save'
					end.to change(Room, :count).by 1
				end

				it 'should redirect to the room list and show a flash success' do
					fill_in 'Number', with: '999'
					click_button 'Save'
					current_url.should == building_floor_rooms_url(floor.building, floor)
					should have_selector '.alert-success'
				end

			end

			describe 'submit with invalid data' do

				it 'should not create a new room' do
					expect do
						click_button 'Save'
					end.not_to change(Room, :count)
				end

				it 'should stay on the edit page and show a flash error' do
					click_button 'Save'
					current_path.should == building_floor_rooms_path(floor.building, floor)
					should have_selector '.alert-error'
				end

			end

		end

	end

	describe 'Edit' do

		let!(:room) { Fabricate :room }

		before { visit edit_building_floor_room_path(room.floor.building, room.floor, room) }

		describe 'page' do
			it { should have_title "Room #{room.number}" }
			it { should have_selector 'legend', text: 'Room' }
			it { should have_field 'Number', with: room.number }
			it { should have_field 'Description', with: room.description }
			it { should have_button 'Save' }
			it { should have_link 'Cancel' }
		end

		describe 'with valid information' do

			let(:new_number) { '999' }
			let(:new_description) { 'New description' }

			before do
				fill_in 'Number', with: new_number
				fill_in 'Description', with: new_description
				click_button 'Save'
			end

			it { should have_selector '.alert-success' }
			it { should have_selector 'td', new_number }
			it { should have_selector 'td', new_description }
			specify { room.reload.number.should == new_number }
			specify { room.reload.description.should == new_description }
			specify { current_url.should == building_floor_rooms_url(room.floor.building, room.floor) }

		end

		describe 'submit with invalid data' do
			it 'should not update the room' do
				expect do
					fill_in 'Number', with: ''
					click_button 'Save'
				end.not_to change { room.reload.number }
			end

			it 'should stay on the edit page and show an error flash' do
				fill_in 'Number', with: ''
				click_button 'Save'
				current_path.should == building_floor_room_path(room.floor.building, room.floor, room)
				should have_selector '.alert-error'
			end
		end

		describe 'cancel' do
			it 'should redirect to the rooms list' do
				click_link 'Cancel'
				current_url.should == building_floor_rooms_url(room.floor.building, room.floor)
			end
		end

	end

	describe 'Show' do

		let(:room) { Fabricate :room }

		before { visit building_floor_room_path room.floor.building, room.floor, room }

		describe 'page' do
			it { should have_title "Room #{room.number}" }
			it { should have_selector 'fieldset[disabled]', text: "Room #{room.number}" }
			it { should have_link 'Back' }
			it { should_not have_button 'Save' }
		end

		describe 'back' do
			it 'should redirect to the rooms list' do
				click_link 'Back'
				current_url.should == building_floor_rooms_url(room.floor.building, room.floor)
			end
		end

	end

	describe 'Delete' do

		let!(:room) { Fabricate :room }

		it 'should delete the room' do
			expect do
				visit building_floor_rooms_path(room.floor.building, room.floor)
				click_link 'Delete', href: building_floor_room_path(room.floor.building, room.floor, room)
			end.to change(Room, :count).by -1
		end

		it 'should redirect to the room list and show a flash success' do
			visit building_floor_rooms_path(room.floor.building, room.floor)
			click_link 'Delete', href: building_floor_room_path(room.floor.building, room.floor, room)
			should have_selector '.alert-success'
			current_url.should == building_floor_rooms_url(room.floor.building, room.floor)
		end

	end

end
