unless ARGV.any? { |a| a =~ /^gems/ } # Don't load anything when running the gems:* tasks
  namespace :docker do
    task :build do
      package = JSON.parse File.read 'bower.json'
      system "docker build -t grappendorf/caretaker:#{package['version']} ."
    end
  end
end
