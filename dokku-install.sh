#!/bin/sh

su -

sed -i -e "s/localhost/`hostname`/g" /etc/hosts

wget https://raw.githubusercontent.com/dokku/dokku/v0.11.2/bootstrap.sh
dokku_TAG=v0.11.2 bash bootstrap.sh

mkdir -p /home/dokku/.ssh
cp /root/.ssh/authorized_keys /home/dokku/.ssh/authorized_keys
sed -i -e "s/PermitRootLogin yes/PermitRootLogin no/g" /etc/ssh/sshd_config
service sshd restart
