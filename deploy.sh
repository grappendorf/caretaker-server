#!/bin/sh
rsync -aczv --delete -e "ssh -i $HOME/.ssh/coyoho-id_rsa" \
	--exclude Gemfile.lock --exclude .git \
	. coyoho@server:coyoho-server
