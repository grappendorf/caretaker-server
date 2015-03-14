#!/bin/sh

mkdir -p /var/log/app/
rails server -e production -p 3000 -b 0.0.0.0
