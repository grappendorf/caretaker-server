db_config = YAML.load_file "#{File.dirname(__FILE__)}/../database.yml"
ActiveRecord::Base.establish_connection(db_config[Application.config.env.to_s])
