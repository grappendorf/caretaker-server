Caretaker Smart Home Server
===========================

This is the server component of the Caretaker Smart Home system. It contains all the backend logic
that controls the remote devices. It also implements a REST API through which the remote devices
can be controlled and the system configuration can be managed. The system configuration is stored
in an SQLite database inside the server component.


Deployment
----------

### Run the server on the development host

* Install RVM for the production user
* Install Ruby 2.3.0
* Create a _caretaker-server_ gemset (created when you enter the project directory) 
* Install all the gems with `bundle install --without=development test`
* Create the production database with `RACK_ENV=production rake db:reset`
* Start the server with `rackup -p 3000`

This starts the REST API server on localhost port 3000. The server also listens for UDP packets on 
port 2000 and 55555 (this can be configured in the file _config/environments/production.rb_`.

### Run the server inside a Docker container

* Build the container image with `./bin/build-server` (the resulting image is named
  _grappendorf/caretaker-server_ and tagged with _latest_ and the current version number) 
* Create a new network with `docker network create caretaker` 
* Then start the container with `bin/start-server`

Note: in a real production environment you need to specify your own secret key base string!
In _bin/start-server_ the same key is used as in the development and test environments.

This script runs a new Docker container with the previously built image and binds port 3000 to the 
development host. Two volumes are created:

* _/var/app/db/sqlite_ contains the SQLite database
* _/root/.hue-lib_ contains configuration data of the _hue-lib_ gem. 

### Verify that the server responds to HTTP requests

If you run for example `http localhost:3000` it should return with status 200 and the following
JSON response: `{ "status": "ok" }`.


Test
----

### Run the tests on the development host

* Execute all steps as described in the development section below, but don't create the 
  development database and don't start the server
* Create the test database with `RACK_ENV=test rake db:drop db:migrate`
* Run the specification tests (RSpec) with `rake test:specs` 
* Run the feature tests (Cucumber) with `rake test:features` 
* Or run all tests with `rake test:all` 

### Run the test in a Docker container

* Build and start the workspace container as described in the _Development_ section below
* Run the specification tests (RSpec) with `./bin/run rake test:specs` 
* Run the feature tests (Cucumber) with `./bin/run rake test:features` 
* Or run all tests with `./bin/run  rake test:all`
 
The _./bin/run_ shell script simply executes the given command with `docker exec` in the workspace 
container.


Development
-----------

### Prerequisites
 
* RVM installed for the development user
* Ruby 2.3.0
* A _caretaker-server_ gemset (created when you enter the project directory) 
* Install all the gems with `bundle install`
* Create the development database with `rake db:reset` (You can also run `rake db:demo` which will 
  create some additional demo data)

### Run the server on the development host with rerun

`rerun -- rackup -p 3000`

This starts the REST API server on localhost port 3000. The server also listens for UDP packets on 
port 2000 and 55555 (this can be configured in the file _config/environments/development.rb_`.

## Run the server inside a Docker container

Note: This only works if the development user on the host has the same user id (1000) as the
user in the Docker container.

* Build the container image with `./bin/build-workspace` (the resulting image is tagged with
  _grappendorf/caretaker-server:workspace_)
* Create a new network with `docker network create caretaker` 
* Then start the workspace with `bin/start-workspace`

This script runs a new Docker container with the previously built image, mounts the gemset and the 
project directory as volumes into the container and binds port 3000 to the development host.
STDIN and STDOUT are attached to the container, so that you can see the log messages and can
control the rerun process. Pressing 'q' terminates the container process and deletes the container.

It takes some time before the server is actually started, because all the gems which have native 
extensions will be re-compiled.


License
-------

The Caretaker Server code is licensed under the MIT license.
You find the license in the attached LICENSE file.


3d Party Software
-----------------

A list of the used 3d party software and graphics can be found in the file 3DPARTY.md.
