wget https://s3.amazonaws.com/aws-cli/awscli-bundle.zip
$ unzip awscli-bundle.zip
$ sudo ./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws

#!/bin/bash

#
# Provisioning for AWS-ElasticBeanstalk-CLI
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# VARIABLES
#
# ------------------------------------------------------------------

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../settings.sh

# get environment from argument if it exist
if [ $# -ne 0 ]; then
    ENV=$1
fi

PHASE="AWS-CLI"
DEPENDENCIES=( )

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

phase_start

echo
echo "Installing dependencies ... "
echo
install_apps DEPENDENCIES[@]

echo
echo "Downloading AWS-CLI ..."
echo
wget --quiet "https://s3.amazonaws.com/aws-cli/awscli-bundle.zip"
echo
echo "Installing AWS-CLI ..."
echo
unzip ./awscli-bundle.zip  > /opt/AWS-CLI.unzip.log
rm -f ./awscli-bundle.zip
./awscli-bundle/install -i /usr/local/aws -b /usr/local/bin/aws
echo
echo "Configuring AWS-CLI ..."
echo

if [ "1" == "${IN_VAGRANT_BOX}" ]; then
    ln -s -f /vagrant/no-vcs/aws_credentials /home/vagrant/.aws
else 
    echo -e "   ${BIPurple}Don't forget to set up your AWS credentials in ~/.aws/${Color_Off}"
fi

update_installed 'AWS-CLI'

phase_finish

exit 0