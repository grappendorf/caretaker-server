#!/bin/bash
VERSION=$(cat lib/version.rb |grep -o -P "(?<=VERSION = ')(.+)(?=')")
docker build -t grappendorf/caretaker:${VERSION} .
