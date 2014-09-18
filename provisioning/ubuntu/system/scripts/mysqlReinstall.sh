#!/bin/bash

#
# Script to reinstall mysql with the initial provisioning config
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# FUNCTIONS
#
# ------------------------------------------------------------------

# reinstall mysql
apt-get purge phpmyadmin mysql-server mysql-common
rm -R /etc/mysql/
rm -R /var/lib/mysql/
${VAGRANT_DEV_HOME}/provisioning/ubuntu/mysql/install.sh
${VAGRANT_DEV_HOME}/provisioning/ubuntu/mysql-dev-utils/install.sh
${VAGRANT_DEV_HOME}/provisioning/ubuntu/mysql-import-dbs/install.sh


exit 0
