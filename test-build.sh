#!/usr/bin/env bash
# shellcheck disable=SC1091
# QnD scipt to build new boxes with packer and load them into to the local
# vagrant registry.
if [[ -f ./vars-build ]]; then
    source ./vars-build
fi
boxName="jessie"
boxPath="$HOME/vms/vagrant/boxes/debian/jessie-virtualbox.box"

# Build the box
date
if ! packer build --only=virtualbox-iso debian-8.6-amd64.json; then
    echo -e "\n\n    Abort! Abort!    \n\n"
    exit 1
fi
date

# Add it to the local Vagrant registry
echo -e "Adding Debian/Jessie to the local registry..."
sleep 5
vagrant box add "$boxName" "$boxPath"
echo ""

# display boxes
vagrant box list
echo ""

# Start the environment
vagrant up #&& vagrant ssh

echo -e ""
echo "Ready for Testing! "
echo -e "\n"
