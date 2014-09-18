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

PHASE="AWS-EB-CLI"
DEPENDENCIES=( ruby )

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

FILE_NAME="AWS-ElasticBeanstalk-CLI-2.6.2.zip"

apt-get install -y python-boto

echo
echo "Downloading AWS-ElasticBeanstalk-CLI ..."
echo
wget --quiet "https://s3.amazonaws.com/elasticbeanstalk/cli/${FILE_NAME}"
echo
echo "Installing AWS-ElasticBeanstalk-CLI ..."
echo
unzip ./${FILE_NAME} -d /opt  > /opt/AWS-ElasticBeanstalk.unzip.log
rm -f ./${FILE_NAME}
echo
echo "Configuring AWS-ElasticBeanstalk-CLI ..."
echo
FOLDER_NAME="${FILE_NAME%.*}"
ln -s -f /opt/${FOLDER_NAME}/eb/linux/python2.7/eb /usr/bin/eb

if [ "1" == "${IN_VAGRANT_BOX}" ]; then
    ln -s -f /vagrant/no-vcs/ebs_credentials /home/vagrant/.elasticbeanstalk
else 
    echo -e "   ${BIPurple}Don't forget to set up your EB credentials in ~/.elasticbeanstalk/${Color_Off}"
fi

update_installed 'AWS-ElasticBeanstalk-CLI'

phase_finish

exit 0