#!/bin/bash
VERSION=$(cat lib/version.rb |grep -o -P "(?<=VERSION = ')(.+)(?=')")
DOCKERFILE=${1:-Dockerfile}
docker build -t grappendorf/caretaker-server:${VERSION} -f $DOCKERFILE .
