#!/usr/bin/env bash
# QnD script to reset test env
declare packerBuildDir="$HOME/vms/packer/builds/debian"

# kill vagrant box
vagrant halt && vagrant destroy -f

# unload it from the local registry
echo -e "Dumping packer boxes from the local Vagrant registry..."
vagrant box remove jessie

if [[ -d "$packerBuildDir" ]]; then
    rm -rf "$packerBuildDir"
fi

# display boxes
vagrant box list

echo -e "\n"
