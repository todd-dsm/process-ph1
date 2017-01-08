#!/usr/bin/env bash
#------------------------------------------------------------------------------
# PURPOSE: Normalize the Debian/Jessie Install and Configuration for the Udemy
#          course: 'Docker for DevOps: From Dev to Prod'
#------------------------------------------------------------------------------
#     URL: https://goo.gl/I9Y1t9
#------------------------------------------------------------------------------
#    EXEC: This script is intended only for Vagrant consumption. Which means:
#            1) It is executed by user: root, and
#            2) Enabled by the Vagrantfile line:
#               config.vm.provision :shell, path: "bootstrap.sh"
#------------------------------------------------------------------------------
#  AUTHOR: Todd E Thomas
#------------------------------------------------------------------------------
#    DATE: 2016/10/23
#------------------------------------------------------------------------------
set -eux

###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------
#export DEBIAN_FRONTEND=noninteractive
#declare osRelease='/etc/os-release'
#source "$osRelease"
declare vagrantHome='/home/vagrant'
#export backupDir="$vagrantHome/backup"
#declare backPortFile='/etc/apt/sources.list.d/docker.list'
#declare grubConf='/etc/default/grub'
declare osPath='/vagrant'
declare osSources="$osPath/sources"
#
#
####----------------------------------------------------------------------------
#### FUNCTIONS
####----------------------------------------------------------------------------
#
#
####----------------------------------------------------------------------------
#### MAIN
####----------------------------------------------------------------------------
#### Backup stuff
####--
#printf '%s\n' "Creating the ~/backup directory..."
#if [[ ! -d "$backupDir" ]]; then
#    mkdir -p "$backupDir"
#    chown -R vagrant:vagrant "$backupDir"
#fi
#
#### Setup ~/.bashrc
#printf '\n\n%s\n' "Setting the ~/.bashrc file..."
#cp -pv "$vagrantHome/.bashrc" "$backupDir/bashrc.orig"
#cp -pv /vagrant/sources/bashrc-debian "$vagrantHome/.bashrc"
#chown vagrant:vagrant "$vagrantHome/.bashrc"
#
#### Prep OS for Docker install
#printf '\n\n%s\n' "Configuring Grub..."
#sed -i '/GRUB_CMDLINE_LINUX_DEFAULT/ s/quiet/cgroup_enable=memory swapaccount=1/g' "$grubConf"
#
#### Gen a new grub2 config
#update-grub
#
####---
#### Package Management
####---
#### Configure Backports
#printf '\n\n%s\n' "Creating backports file for $PRETTY_NAME..."
#cat <<EOF > "$backPortFile"
#deb https://apt.dockerproject.org/repo debian-jessie main
#EOF
#
#### Import the keys for the current docker apt repository
#### URL: https://goo.gl/JnNrJC
#apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 \
#    --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
#
#### Install packages
#printf '\n\n%s\n' "Updating the OS and installing some stuff..."
#apt-get -y install apt-transport-https
#apt-get update
#apt-cache policy docker-engine
#apt-get -y install docker-engine
#
#### install docker-compose
#printf '\n\n%s\n' "Pulling the latest docker-compose..."
#pip install docker-compose
#
####---
#### finalize system work
####---
#### Add user to docker group
#printf '\n\n%s\n' "Adding user to the docker group..."
#usermod -aG docker vagrant
#
#### Enable and Init Docker
#printf '\n\n%s\n' "Enabling and initializing docker..."
#systemctl enable docker
##service docker start
#systemctl start docker
#systemctl -l status docker
#
#
####---
#### Copy keys for github
####---
#printf '\n\n%s\n' "Prepping ssh stuff..."
## FIX this later
##sed -i 's/.*StrictHostKeyChecking.*/StrictHostKeyChecking no/g' /etc/ssh/ssh_config
#ssh-keyscan github.com >> "$vagrantHome/.ssh/known_hosts"
#chown vagrant:vagrant     "$vagrantHome/.ssh/known_hosts"
#
##printf '\n\n%s\n' "Number of keys in known_hosts: "
##wc -l < "$vagrantHome/.ssh/known_hosts"
#
##printf '\n\n%s\n' "Display github remote host keys: "
##cat "$vagrantHome/.ssh/known_hosts"
#
###---
### MOVE TO PACKER SCRIPT: scripts/common/vagrant.sh
### Keys should never exist in the final build intended for public use.
###---
printf '\n\n%s\n' "Pulling in build keys..."
#cp -fv "$osSources"/id_rsa* "$vagrantHome/.ssh"
cp -fv "$osSources"/builder "$vagrantHome/.ssh/id_rsa"
cp -fv "$osSources"/builder.pub "$vagrantHome/.ssh/id_rsa.pub"
chown -R vagrant:vagrant "$vagrantHome/.ssh"
find "$vagrantHome/.ssh" -type f -name 'builder*' -exec chmod 600 {} \;


###---
### Prep for testing
### Grab the code; we're root, become vagrant for a moment. He has the keys...
###---
printf '\n\n%s\n' "Pulling the code in for testing..."
cp "$osSources/git-code.sh" "$vagrantHome/git-code.sh"


###---
### Ensure permissions
###---
chown vagrant:vagrant "$vagrantHome/git-code.sh"
chmod u+x  "$vagrantHome/git-code.sh"


###---
### Pull the code (deploy keys)
###---
su -l vagrant -c  "$vagrantHome/git-code.sh"


###---
### Cleanup work
###---
rm -f "$vagrantHome/git-code.sh"

exit 0
###---
### Starting the app
###---
cd mobydock/feeder/

type -P docker-compose
if [[ $? -eq 0 ]]; then
    docker-compose up
fi

###---
### fin~
###---
