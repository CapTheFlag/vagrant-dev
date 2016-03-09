#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== YUM.SH =========="
echo

. /vagrant/config.sh

#
# EPEL - Extra Packages for Enterprise Linux
#
cp /vagrant/provisioning/templates/yum/epel.repo /etc/yum.repos.d/epel.repo
chown -R root:root /etc/yum.repos.d/epel.repo
chmod -R 770 /etc/yum.repos.d/epel.repo
cp /vagrant/provisioning/templates/yum/RPM-GPG-KEY-EPEL-6 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
chown -R root:root /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
chmod -R 770 /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6
rpm --import /etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-6

#
# REMI - Contains much more up to date packages
#
cp /vagrant/provisioning/templates/yum/remi.repo /etc/yum.repos.d/remi.repo
chown -R root:root /etc/yum.repos.d/remi.repo
chmod -R 770 /etc/yum.repos.d/remi.repo
rpm --import http://rpms.famillecollet.com/RPM-GPG-KEY-remi

#
# jpackage - JAVA packages repo
#
wget http://jpackage.org/jpackage50.repo -O /etc/yum.repos.d/jpackage50.repo
chown -R root:root /etc/yum.repos.d/jpackage50.repo
chmod -R 770 /etc/yum.repos.d/jpackage50.repo
rpm --import http://www.jpackage.org/jpackage.asc

echo
echo "========== FINISHED YUM.SH =========="
echo
