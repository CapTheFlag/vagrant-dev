#!/bin/bash

#
# Script for deployment and mounting of S3fs
#
# @author Herberto Graca <herberto@videodock.com>
#
# Version: 2.0.0

if [ "$UID" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi


CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
echo "Script dir: '${CURRENT_DIR}'"
cd ${CURRENT_DIR}

OS_DESCRIPTION=`uname -a`
OS='unknown'

if [[ $OS_DESCRIPTION == *Ubuntu* ]]; then
    OS='debian_based'
    PACKAGE_NAME='mp4split_1.6.6_ubuntu12_amd64'
elif [[ $OS_DESCRIPTION == *amzn1* ]]; then
    OS='redhat_based'
    PACKAGE_NAME='mp4split-1.6.6-amli-201309.x86_64'
fi
echo $OS_DESCRIPTION
echo $OS

INSTALL_DIR='/opt/mp4split'

echo
echo "Install mp4split"
echo

# remove old if exists
rpm -e ${PACKAGE_NAME}
rm -f /usr/bin/mp4split
rm -Rf ${INSTALL_DIR}

case $OS in

    debian_based)
        echo "installing for a Debian based SO"
        dpkg -i ${CURRENT_DIR}/${PACKAGE_NAME}.deb
        # just in case there are unmet dependencies:
        apt-get install -y -f
        dpkg -i ${CURRENT_DIR}/${PACKAGE_NAME}.deb
        ;;

    redhat_based)
        echo "installing for a Red Hat based SO"
        #uninstall previous installation
        rpm -e ${PACKAGE_NAME}
        rpm -ivh ${CURRENT_DIR}/${PACKAGE_NAME}.rpm
        ;;

    *)
        echo "OS type not recognised. Available options: {debian_based, redhat_based}"
        exit 1
        ;;

esac

# install
mkdir -p ${INSTALL_DIR}
cp ${CURRENT_DIR}/mp4split.key ${INSTALL_DIR}/mp4split.key
cp ${CURRENT_DIR}/mp4split.sh ${INSTALL_DIR}/mp4split.sh

mv /usr/bin/mp4split ${INSTALL_DIR}/mp4split.exe
ln -sf ${INSTALL_DIR}/mp4split.sh /usr/bin/mp4split

touch /var/log/mp4split.log
chmod a+rw /var/log/mp4split.log

chmod -R 777 ${INSTALL_DIR}

echo
echo "Done"
echo


exit 0
