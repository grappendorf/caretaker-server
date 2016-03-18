#!/bin/bash -l

echo "Copy host gems into container"
cp -a /rvm/gems/ruby-2.3.0@caretaker-server ~/.rvm/gems

echo "Install gems and rebuild native extensions"
bundle install
ruby -e 'puts Gem::Specification.select{|s|not s.extensions.empty?}.map{|s|"#{s.name}"}' \
| xargs gem pristine

echo "Start the application"
script -c 'rerun -- "rackup -p 3000 -o 0.0.0.0"' /dev/null
