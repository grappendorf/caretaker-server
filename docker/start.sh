#!/bin/sh

mkdir -p /var/log/app/
rm -rf tmp/pids
rails server -e production -p 3000 -b 0.0.0.0
