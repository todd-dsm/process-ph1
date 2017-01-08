#!/usr/bin/env bash
#------------------------------------------------------------------------------
# PURPOSE:
#------------------------------------------------------------------------------
#     URL:
#------------------------------------------------------------------------------
#    EXEC: This script is intended only for Vagrant consumption. Which means:
#            1) It is executed by user: root, and
#------------------------------------------------------------------------------
#  AUTHOR: Todd E Thomas
#------------------------------------------------------------------------------
#    DATE: 2016/10/23
#------------------------------------------------------------------------------
set -eux

###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------
declare vagrantHome='/home/vagrant'
export GIT_CURL_VERBOSE=1
export GIT_TRACE=1
declare gitRepo='git@github.com:todd-dsm/mobydock.git'


###----------------------------------------------------------------------------
### FUNCTIONS
###----------------------------------------------------------------------------


###----------------------------------------------------------------------------
### MAIN
###----------------------------------------------------------------------------
### Prep for testing
###---
### Grab the code
#printf '\n\n%s\n' "Verify GIT variables in ENV..."
#env | grep -i GIT

printf '\n\n%s\n' "Pulling the code in for testing..."
git clone $gitRepo "$vagrantHome/mobydock"


#printf '\n\n%s\n' "New number of keys in known_hosts: "
#wc -l < "$vagrantHome/.ssh/known_hosts"

#printf '\n\n%s\n' "Display github remote host keys: "
#cat "$vagrantHome/.ssh/known_hosts"


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
