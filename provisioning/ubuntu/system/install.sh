#!/bin/bash

#
# Provisioning for system utilities
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

# get environment from argument if it exist
if [ $# -ne 0 ]; then
    HOSTNAME=$2
fi

DEPENDENCIES=(  )

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

echo
echo "Installing dependencies ... "
echo
install_apps DEPENDENCIES[@]


echo
echo "Applying generic settings ... "
echo
mkdir -p /var/log/idenv
chmod -R a+rw /var/log/idenv

if [ "1" == "${IN_VAGRANT_BOX}" ]; then
    rm -f /home/vagrant/.nano_history
    touch /home/vagrant/.nano_history
    chown vagrant:vagrant /home/vagrant/.nano_history
fi

echo ${HOSTNAME} > /etc/hostname
hostname ${HOSTNAME}

echo "${APP_DB_HOST_IP} dbhost" >> /etc/hosts

# ------------------------------------------------------------------

echo
echo "Installing extra deb sources ... "
echo
wget -q -O - http://archive.getdeb.net/getdeb-archive.key | sudo apt-key add -
sh -c 'echo "deb http://archive.getdeb.net/ubuntu trusty-getdeb games" >> /etc/apt/sources.list.d/getdeb.list'
apt-get update

# ------------------------------------------------------------------

echo
echo "Installing system utilities ... "
echo
# nfs                          is used by vagrant to share folders (its faster than the default filesystem)
# nfs-kernel-server            NFS Server
# nfs-common                   NFS client
# cachefilesd                  NFS cache
# python-software-properties   installs 'add-apt-repository'
# cachefilesd                  NFS cache system
# acl                          is used by symfony for the cache and log folders
# sysv-rc-conf                 To setup services
# rcconf                       Handy tool to set up startup services
# mailutils                    This couses problems when installing because it does not install unassisted
apt-get -y install tree build-essential zip unzip python-software-properties acl debconf-utils sysv-rc-conf rcconf curl htop
# apt-get -y install nfs-common nfs-kernel-server

# ------------------------------------------------------------------

# echo
# echo "Setting up nfs cache ... "
# echo
# cp /etc/mtab /etc/mtab.bkp
# cat /etc/mtab.bkp | sed -e "s@nfs rw,vers@nfs rw,fsc,vers@" > /etc/mtab
# mount -o remount 192.168.1.1:${HOST_PATH_TO_IDW}/workspace/www
# cp /etc/default/cachefilesd /etc/default/cachefilesd.bkp
# cat /etc/default/cachefilesd.bkp | sed -e "s@#RUN=yes@RUN=yes@" > /etc/default/cachefilesd
# service cachefilesd restart

# ------------------------------------------------------------------

# Curently decided to not use ACL or symfony and set the umask instead
# echo
# echo "Setting up ACL ... "
# echo
# cp /etc/fstab /etc/fstab.bkp
# cat /etc/fstab.bkp | sed -e "s@errors=remount-ro@acl,errors=remount-ro@" > /etc/fstab
# sudo mount -o remount /

# ------------------------------------------------------------------

echo
echo "Setting up links to the shared utilities ... "
echo
DESTINATION="/usr/bin"

# make sure the filenames dont have spaces
find ${ORIGIN} -name "*.sh" -type f | rename 's/ /_/g'

# for the default scripts
ORIGIN="${DIR}/scripts"
FILES=`find ${ORIGIN} -type f -print`
for FILE in ${FILES[@]}; do
    LINK_NAME=`basename ${FILE} .sh`
    LINK_NAME=`echo ${LINK_NAME} | tr '[:upper:]' '[:lower:]'`
    ln -sf ${FILE} ${DESTINATION}/${LINK_NAME}
done

# for files outside the vagrant-dev
ORIGIN="${ROOT_PROVISIONING}/system/scripts"
if [ -d ${ORIGIN} ]; then
    # make sure the filenames dont have spaces
    find ${ORIGIN} -name "*.sh" -type f | rename 's/ /_/g'

    FILES=`find ${ORIGIN} -type f -print`

    for FILE in ${FILES[@]}; do
        LINK_NAME=`basename ${FILE} .sh`
        LINK_NAME=`echo ${LINK_NAME} | tr '[:upper:]' '[:lower:]'`
        ln -sf ${FILE} ${DESTINATION}/${LINK_NAME}
    done
fi

# ------------------------------------------------------------------

echo
echo "Setting up the ssh keys ... "
echo
/usr/bin/sshupdate

# ------------------------------------------------------------------

echo
echo "Setting the hosts file ..."
echo
cp -f ${ROOT_PROVISIONING}/system/hosts /etc/hosts

# ------------------------------------------------------------------

echo
echo "Setting up the Time Zone ... "
echo
setTimezone ${TIMEZONE}

# ------------------------------------------------------------------

echo
echo "Setting up the Language ... "
echo "fix for 'Sorry, command-not-found has crashed!' and 'locale: Cannot set LC_ALL to default locale: No such file or directory'"
echo
echo "
LANG=en_US.utf8
LANGUAGE=en_US.UTF-8
LC_CTYPE=en_US.UTF-8
LC_NUMERIC=en_US.UTF-8
LC_TIME=en_US.UTF-8
LC_COLLATE=en_US.UTF-8
LC_MONETARY=en_US.UTF-8
LC_MESSAGES=en_US.UTF-8
LC_PAPER=en_US.UTF-8
LC_NAME=en_US.UTF-8
LC_ADDRESS=en_US.UTF-8
LC_TELEPHONE=en_US.UTF-8
LC_MEASUREMENT=en_US.UTF-8
LC_IDENTIFICATION=en_US.UTF-8
LC_ALL=en_US.UTF-8" > /etc/default/locale
export LANGUAGE=en_US.UTF-8
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
echo "export LANGUAGE=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LANG=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LC_ALL=en_US.UTF-8" >> /etc/bash.bashrc
echo "export LC_CTYPE=en_US.UTF-8" >> /etc/bash.bashrc
locale-gen en_US.UTF-8
locale-gen nl_NL.UTF-8
locale-gen pt_PT.UTF-8
sudo dpkg-reconfigure locales

# ------------------------------------------------------------------

echo
echo "Setting up sendmail ... "
echo
apt-get -y install sendmail &>> /dev/null
cp ${DIR}/templates/sendmail/sendmail.conf /etc/mail/sendmail.conf
cp ${DIR}/templates/sendmail/sendmail /etc/cron.d/sendmail
cp ${DIR}/templates/sendmail/sendmail.mc /etc/mail/sendmail.mc
service sendmail restart

# ------------------------------------------------------------------

# echo
# echo "Setting up cron boot service ... "
# echo
# update-rc.d cron defaults
# For centos:
# chekconfg crond on

# ------------------------------------------------------------------

echo
echo "fix for 'locate: can not stat () '/var/lib/mlocate/mlocate.db' ' "
updatedb

exit 0
