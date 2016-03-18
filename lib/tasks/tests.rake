unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks
  namespace :test do
    desc 'Run all spec tests (RSpec)'
    task :specs do
      require 'rspec/core/rake_task'
      RSpec::Core::RakeTask.new('test:_rspec') do |task|
        task.verbose = false
      end
      Rake::Task['test:_rspec'].invoke
    end

    desc 'Run all feature tests (Cucumber)'
    task :features do
      require 'cucumber/rake/task'
      Cucumber::Rake::Task.new('test:_cucumber') do |task|
        task.cucumber_opts = '-q -f progress'
      end
      Rake::Task['test:_cucumber'].invoke
    end

    desc 'Run all tests (enable coverage with coverage=y)'
    task :all => ['test:specs', 'test:features'] do
    end
  end
end
