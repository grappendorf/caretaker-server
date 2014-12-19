#!/bin/sh

mkdir -p /var/log/app/
rails server -e production -p 80
