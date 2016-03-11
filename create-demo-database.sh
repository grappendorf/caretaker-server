#!/bin/bash

export APP_ENV=demo
rake db:drop
rake db:migrate
rake db:seed
rake db:demo
