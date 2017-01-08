#!/usr/bin/env bash
set -eux

export DEBIAN_FRONTEND=noninteractive
arch="$(uname -r)"

### Update all packages
apt-get update

# install Linux kernel build stuff
apt-get -y upgrade linux-image-"${arch##*-}"
apt-get -y install "linux-headers-$arch"

# package removals
apt-get -y --purge remove vim-tiny nano

# dev utils / app support
apt-get -y install vim git python
# sysadmin utils
apt-get -y install strace tree apt-transport-https

# TODO update the find package db
#apt-get -y install apt-find
#apt-find update

if [ -d /etc/init ]; then
    # update package index on boot
    cat <<EOF >/etc/init/refresh-apt.conf;
description "update package index"
start on networking
task
exec /usr/bin/apt-get update
EOF
fi
