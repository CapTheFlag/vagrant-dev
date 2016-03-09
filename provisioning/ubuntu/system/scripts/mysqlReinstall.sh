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
${ROOT_PROVISIONING}/ubuntu/mysql/install.sh
${ROOT_PROVISIONING}/ubuntu/mysql-dev-utils/install.sh
${ROOT_PROVISIONING}/ubuntu/mysql-import-dbs/install.sh


exit 0
