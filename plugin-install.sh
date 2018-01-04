#!/bin/sh

su -

dokku config:set --global TZ="Asia/Tokyo"
dokku config:set --global LANG="ja_JP.UTF-8"

dokku plugin:install https://github.com/dokku/dokku-mysql.git
dokku plugin:install https://github.com/dokku/dokku-postgres.git
dokku plugin:install https://github.com/michaelshobbs/dokku-logspout.git
