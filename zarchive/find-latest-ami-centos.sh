#!/usr/bin/env bash
# -----------------------------------------------------------------------------
#              ****     UNFINISHED      ****
# PURPOSE:  AMI IDs change occasionally. This will find and output the latest
#           Debian Jessie AMI ID.
#             * Specify the region: us-west-2
#             * Output text: ami-amiId
# -----------------------------------------------------------------------------
#    EXEC: ./find-latest-ami-rhel.sh --region some-region
# -----------------------------------------------------------------------------
#   NOTES: See notes here:  https://goo.gl/sAEs8E
#          AMI IDs change occasionally.
#          multiple AMIs probablility is high for catastrophic effect.
# -----------------------------------------------------------------------------
#          ***       THIS SCRIPT MUST BE UPDATED BEFORE USING IN PROD       ***
# -----------------------------------------------------------------------------
#    TODO: 1) This script will breat in the event there is more than 1 AMI ID
#             found. An array may be necessary later.
# -----------------------------------------------------------------------------
#  AUTHOR: Todd E Thomas
# -----------------------------------------------------------------------------
#    DATE: 2016/08/01
# -----------------------------------------------------------------------------
set -x


###----------------------------------------------------------------------------
### VARIABLES
###----------------------------------------------------------------------------


###----------------------------------------------------------------------------
### FUNCTIONS
###----------------------------------------------------------------------------
### Isolate an AMI
###---
getAMITargets() {
  local region_name="$1"
  aws ec2 describe-images                               \
    --filters                                           \
      Name=architecture,Values=x86_64                   \
      Name=virtualization-type,Values=hvm               \
      Name=root-device-type,Values=ebs                  \
      Name=block-device-mapping.volume-type,Values=gp2  \
  --owners 379101102735                                 \
  --region "$region_name"                               \
  --query 'Images[]|[?contains(Name, `jessie`) == `true`].ImageId'  \
  --output text
}


###----------------------------------------------------------------------------
### MAIN PROGRAM
###----------------------------------------------------------------------------
### Main Script Logic
###---
if [ -z "$1" ]; then
    for region_name in $(aws ec2 describe-regions --query "sort(Regions[].RegionName)" --output text); do
        getAMITargets "$region_name"
    done
else
    case "$1" in
        -r|--region)
            shift
            region_name="$1"
            ;;
        *)
            echo "usage: latest-amis [-r | --region]" 1>&2
            exit 1
    esac
    getAMITargets "$region_name"
fi
