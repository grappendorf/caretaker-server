unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks
  namespace :docker do
    task :workspace do
      require_relative '../version'
      system "docker build -t grappendorf/caretaker-server:workspace -f docker/Dockerfile.workspace ."
    end
  end
  namespace :docker do
    task :image do
      require_relative '../version'
      system "docker build -t grappendorf/caretaker-server:latest -f docker/Dockerfile ."
      system "docker tag grappendorf/caretaker-server:latest grappendorf/caretaker-server:#{VERSION}"
    end
  end
end
