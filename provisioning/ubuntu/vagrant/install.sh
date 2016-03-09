#!/bin/bash

#
# Script for instalation of php in a vagrant VBox with ubuntu
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

PHASE="VAGRANT"
DEPENDENCIES=( virtualbox )

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

# wget http://files.vagrantup.com/packages/a40522f5fabccb9ddabad03d836e120ff5d14093/vagrant_1.3.5_x86_64.deb
#dpkg -i vagrant_1.3.5_x86_64.deb
#rm vagrant_1.3.5_x86_64.deb
apt-get -y install nfs-kernel-server nfs-common
wget -O vagrant.deb https://dl.dropboxusercontent.com/u/17350177/software/vagrant_1.5.1_x86_64.deb
dpkg -i vagrant.deb
rm vagrant.deb
# apt-get -y install linux-headers-$(uname -r)
# dpkg-reconfigure virtualbox-dkms

# echo
# echo "Installing guest additions plugin for vagrant ... "
# echo
# vagrant plugin install vagrant-vbguest

update_installed 'vagrant'



echo
echo "Download boxes ..."
echo "The host installation is finished, I can download some boxes for you (might take a while) ..."
echo

echo "Download Ubuntu Server 12.04 box? [Y/n] "
read answer
if [ "$answer" != "n" ]; then
    wget -P ./provisioning/boxes/ ${UBUNTU_SERVER_1204_BOX_URL}/${UBUNTU_SERVER_1204_BOX_NAME}
fi

echo "Download Ubuntu Server 13.04 box? [Y/n] "
read answer
if [ "$answer" != "n" ]; then
    wget -P ./provisioning/boxes/ ${UBUNTU_SERVER_1304_BOX_URL}/${UBUNTU_SERVER_1304_BOX_NAME}
fi

echo "Download Ubuntu Server 13.10 box? [Y/n] "
read answer
if [ "$answer" != "n" ]; then
    wget -P ./provisioning/boxes/ ${UBUNTU_SERVER_1310_BOX_URL}/${UBUNTU_SERVER_1310_BOX_NAME}
fi

phase_finish

exit 0
