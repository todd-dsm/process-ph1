#!/bin/bash
# PURPOSE: A QnD script to discover which shell is being used for execution.
set -eux

###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------
export DEBIAN_FRONTEND=noninteractive


###----------------------------------------------------------------------------
### SHELL TESTING
###----------------------------------------------------------------------------


###----------------------------------------------------------------------------
### MAIN
###----------------------------------------------------------------------------
### Get the default shell
###---
ps -p "$$"


###---
### Who is the excutor?
###---
whoami


###---
### Where does that shell point?
###---
ls -l /bin/sh


###---
### Switch /bin/sh -> bash
###---
echo 'dash dash/sh boolean false' | debconf-set-selections && \
    dpkg-reconfigure -p 'high' dash

### Where does that shell point now?
ls -l /bin/sh


###---
### Get details about the current shell
###---
### pull whatshell down
wget http://www.in-ulm.de/~mascheck/various/whatshell/whatshell.sh

### make it executable
chmod u+x whatshell.sh


###---
### What Shell ran the script?
###---
./whatshell.sh


###---
### Remove the script
###---
rm -f whatshell.sh


###---
### Fin~
###---
exit 0
