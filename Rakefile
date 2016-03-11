require 'yaml'
require 'logger'
require 'active_record'
require File.expand_path('../config/application', __FILE__)

task :environment do
  ActiveRecord::Base.configurations = DatabaseTasks.database_configuration
  ActiveRecord::Base.establish_connection DatabaseTasks.env.to_sym
end

Dir["#{File.dirname(__FILE__)}/lib/tasks/*.rake"].each { |f| load f }
