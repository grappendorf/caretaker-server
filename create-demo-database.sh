#!/bin/bash

export RACK_ENV=demo
rake db:drop
rake db:migrate
rake db:seed
rake db:demo
