require 'spec_helper'

describe 'Buildings API', type: :request do

  subject { response }

  let(:user) { Fabricate :admin }

  before { sign_in user }
  after { sign_out }


  describe 'GET /buildings' do

    before do
      3.times { Fabricate :building }
      get buildings_path
    end

    it 'should return all buildings' do
      json = JSON.parse response.body
      expect(json.length).to eq 3
      expect(json.map { |b| b['name'] }).to eq Building.all.pluck :name
    end

    it 'should return the required building properties' do
      json = JSON.parse response.body
      expect(json[0]).to have_key 'id'
      expect(json[0]).to have_key 'name'
      expect(json[0]).to have_key 'description'
    end

    it 'should return with status :ok' do
      expect(response).to have_http_status :ok
    end
  end


  describe 'GET /buildings/:id' do

    let!(:building) { Fabricate :building }

    before do
      get building_path building
    end

    it 'should return the building' do
      json = JSON.parse response.body
      expect(json).to eq building.attributes
    end

    it 'should return with status :ok' do
      expect(response).to have_http_status :ok
    end
  end


  describe 'POST /buildings' do

    let(:building_name) { 'New Building' }
    let(:building_description) { 'A theater' }
    let(:building_params) { { name: building_name, description: building_description }.to_json }

    context 'with valid parameters' do

      it 'should create a new building' do
        expect do
          post buildings_path, building_params
        end.to change { Building.count }.by 1
        expect(Building.first.name).to eq building_name
        expect(Building.first.description).to eq building_description
      end

      it 'should return with status :ok' do
        post buildings_path, building_params
        expect(response).to have_http_status :ok
      end
    end

    context 'with invalid parameters' do

      let(:building_name) { '' }

      it 'should not create a new building' do
        expect do
          post buildings_path, building_params
        end.not_to change { Building.count }
      end

      it 'should return the erroneous attributes' do
        post buildings_path, building_params
        json = JSON.parse response.body
        expect(json['errors']).to have_key 'name'
      end

      it 'should return with status :bad_request' do
        post buildings_path, building_params
        expect(response).to have_http_status :bad_request
      end
    end
  end


  describe 'PUT /buildings/:id' do

    let(:building_name) { 'Updated building' }
    let(:building_params) { { name: building_name }.to_json }

    let!(:building) { Fabricate :building }

    context 'with valid parameters' do

      it 'should update the building' do
        put building_path(building), building_params
        expect(building.reload.name).to eq building_name
      end

      it 'should return with status :ok' do
        put building_path(building), building_params
        expect(response).to have_http_status :ok
      end
    end

    context 'with invalid parameters' do

      let(:building_name) { '' }

      it 'should not modify the building' do
        expect do
          put building_path(building), building_params
        end.not_to change { building.reload.name }
      end

      it 'should return with status :bad_request' do
        put building_path(Building.first), building_params
        expect(response).to have_http_status :bad_request
      end
    end
  end


  describe 'DELETE /buildings/:id' do

    before { Fabricate :building }

    it 'should delete the building' do
      expect do
        delete building_path Building.first
      end.to change { Building.count }.by -1
    end

    it 'should return with status :ok' do
      delete building_path Building.first
      expect(response).to have_http_status :ok
    end
  end


  describe 'GET /buildings/names' do

    before { 3.times { Fabricate :building } }

    it 'should return the id and the name of all buildings' do
      get names_buildings_path
      json = JSON.parse response.body
      expect(json.length).to eq 3
      expect(json).to match_array Building.all.map(&:attributes).map { |b| b.slice 'id', 'name' }
    end
  end
end
