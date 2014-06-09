require 'spec_helper'

describe SingletonService do

	class SomeSingletonService < SingletonService
		def some_service_method
		end
	end

	let(:previously_started_service) {}
	subject(:service) { SomeSingletonService.new }

	before(:each) do
		FileUtils.rm_f SomeSingletonService.uri_file
		previously_started_service
		service
	end

	after(:each) do
		previously_started_service.try :stop
		service.stop
	end

	describe '#new' do

		context 'when no service instance has been created yet' do
			it 'should create a new one with a DRb server' do
				service.should be_a_kind_of SingletonService
				service.server.should be_alive
			end

			it 'should create a file containing the service uri' do
				File.read(SomeSingletonService.uri_file).should match /druby:\/\/[^:]+:\d+/
			end
		end

		context 'when another service instance has already been created' do
			let(:previously_started_service) { SomeSingletonService.new }

			it 'should create a DRb client for the existing one' do
				service.should be_a_kind_of DRbObject
			end
		end

		context 'when called with a block ' do
			let(:actual_service) { 'actual_service_instance' }
			subject(:service) { SingletonService.new { actual_service } }
			it 'creates the service instance yielding this block' do
				service.should eql actual_service
			end
		end

	end

	describe '#stop' do

		context 'when this is the real service instance' do
			it 'should delete the file containing the service uri' do
				service.stop
				expect(File).not_to exist SomeSingletonService.uri_file
			end

			it 'should stop the DRb server' do
				service.stop
				service.server.should_not be_alive
			end
		end

		context 'when this is a proxy service instance' do
			let(:previously_started_service) { SomeSingletonService.new }

			it 'should not delete the file containing the service uri' do
				service.stop
				expect(File).to exist SomeSingletonService.uri_file
			end

			it 'should not call the real service #stop method' do
				expect(previously_started_service).to receive(:stop).once
				service.stop
			end
		end

	end

	describe '#start' do

		context 'when this is a proxy service instance' do
			let(:previously_started_service) { SomeSingletonService.new }

			it 'should not call the real service #start method' do
				expect(previously_started_service).not_to receive(:start)
				service.start
			end
		end

	end

	describe 'calling a service method' do
		context 'when this is the real service instance' do
			it 'should call the service method' do
				expect(service).to receive(:some_service_method)
				service.some_service_method
			end
		end

		context 'when this is a proxy service instance' do
			let(:previously_started_service) { SomeSingletonService.new }
			it 'should call the service method' do
				expect(previously_started_service).to receive(:some_service_method)
				service.some_service_method
			end
		end
	end

end
