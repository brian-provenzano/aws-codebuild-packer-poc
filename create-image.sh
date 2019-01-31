#!/bin/bash -e
#
# This script creates images using Hashicorp Packer 
# Currently uses simple shell provisioner to run the setup bootstrap to create image
# https://www.packer.io/docs/index.html
# https://www.packer.io/docs/commands/build
#
# Usage:
# create-image.sh <ami-name> <packer-templatepath> <aws-accesskey> <aws-secretkey> <aws-region> <aws-instancetype>
#
# Notes:
# Must have packer installed and in your path
# Puts AMIs in the AMI registry in AWS
# If process fails packer will cleanup after itself and delete anything it created 
# m5.large default
#
# Author:
# Hosting 12/2018

#simple check for required args then release the hounds...
if [[ $# -ne 8 ]] ; then
    echo "This script requires 8 arguments: [ create-image.sh <ami-name> <packer-templatepath> <aws-accesskey> <aws-secretkey> <aws-region> <aws-instancetype> <aws-imageid> <aws-instanceprofile> ]"
    exit 1
fi

set -x
args=("$@")
AMI_NAME=${args[0]}
TEMPLATE_PATH=${args[1]}
set +x
AWS_ACCESS_KEY_ID=${args[2]}
AWS_SECRET_ACCESS_KEY=${args[3]}
set -x
AWS_REGION=${args[4]}
AWS_INSTANCETYPE=${args[5]}
AWS_IMAGEID=${args[6]}
AWS_INSTANCEPROFILE=${args[7]}
set +x
packer build -var 'aws_access_key='"${AWS_ACCESS_KEY_ID}"'' -var 'aws_secret_key='"${AWS_SECRET_ACCESS_KEY}"'' \
    -var 'aws_region='"${AWS_REGION}"'' -var 'aws_instance_type='"${AWS_INSTANCETYPE}"'' \
    -var 'aws_aminame='"${AMI_NAME}"'' -var 'aws_imageid='"${AWS_IMAGEID}"'' \
    -var 'aws_instanceprofile='"${AWS_INSTANCEPROFILE}"'' \
    "${TEMPLATE_PATH}"