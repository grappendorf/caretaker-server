unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks

  begin

    namespace :test do

      desc 'Run all tests (enable coverage with coverage=y)'
      task :all do

        require 'rspec/core/rake_task'
        RSpec::Core::RakeTask.new(:_specs) do |task|
          task.verbose = false
        end
        Rake::Task[:_specs].invoke

        require 'cucumber/rake/task'
        Cucumber::Rake::Task.new(:_features) do |task|
          task.cucumber_opts = '-q -f progress'
        end
        Rake::Task[:_features].invoke

      end

    end

  end

end
