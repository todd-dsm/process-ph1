#!/bin/bash
set -eux

###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive
vagrantHome='/home/vagrant'
backupDir="$vagrantHome/backup"
bac
buildInfo='/etc/build-info'
osPath='/vagrant'
osSources="$osPath/sources"


###----------------------------------------------------------------------------
### MAIN
###----------------------------------------------------------------------------
### Get the the Draios GPG key
###---
printf '\n%s\n' "Pulling the GPG key..."
curl -s https://s3.amazonaws.com/download.draios.com/DRAIOS-GPG-KEY.public | \
    apt-key add -


###---
### Create a back ports file
###---
printf '\n%s\n' "Creating backup space..."
curl -s -o /etc/apt/sources.list.d/draios.list
http://download.draios.com/stable/deb/draios.list

###---
### Create file for build info
###---
printf '\n%s\n' "Creating build tag..."
bTag="$(date '+%Y%m%d-%H%M%S')"
echo "Build date/time: $bTag" > "$buildInfo"

