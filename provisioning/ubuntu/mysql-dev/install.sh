#!/bin/bash

#
# Provisioning for mysql
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

echo
echo "Installing phpMyAdmin ... "
echo

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../settings.sh

# get environment from argument if it exist
if [ $# -ne 0 ]; then
    ENV=$1
fi

PHASE="MYSQL-DEV"
DEPENDENCIES=( php mysql )

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

echo "phpmyadmin phpmyadmin/dbconfig-install boolean true" | debconf-set-selections
echo "phpmyadmin phpmyadmin/reconfigure-webserver multiselect apache2" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/admin-pass password ${MYSQL_ROOT_PASS}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/mysql/app-pass password ${PHPMYADMIN_ROOT_PASS}" | debconf-set-selections
echo "phpmyadmin phpmyadmin/app-password-confirm password ${PHPMYADMIN_ROOT_PASS}" | debconf-set-selections

# Unnatended install of phpmyadmin
export DEBIAN_FRONTEND=noninteractive
apt-get -q -y install phpmyadmin
export DEBIAN_FRONTEND=''

# Prevent phpmyadmin to logout after a few minutes
if [ "$ENV" == "dev" ]; then
    echo '

    /*
    * Prevent timeout for a week at a time.
    * (seconds * minutes * hours * days)
    */
    //$cfg["Servers"][$i]["LoginCookieValidity"] = 60*60*24*7;
    $cfg["LoginCookieValidity"] = 60*60*24*7;
    ini_set("session.gc_maxlifetime", $cfg["LoginCookieValidity"]);' >> /etc/phpmyadmin/config.inc.php

    replaceText /etc/php5/apache2/php.ini "^session.gc_maxlifetime = 1440" "session.gc_maxlifetime = 691200"
fi

service apache2 restart

echo
echo "Done"
echo
echo "You can access phpmyadmin from http://<hostname_or_IP>/phpmyadmin"
echo

# ${VAGRANT_DEV_HOME}/provisioning/fragments/server-php.sh

# rpm --import http://dag.wieers.com/rpm/packages/RPM-GPG-KEY.dag.txt
# yum -y install http://pkgs.repoforge.org/rpmforge-release/rpmforge-release-0.5.2-2.el6.rf.i686.rpm
# yum -y install phpmyadmin

# mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
# cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@<Directory "/usr/share/phpmyadmin">@#<Directory "/usr/share/phpmyadmin">@' > /etc/httpd/conf.d/phpmyadmin.conf
# rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

# mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
# cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@  Order Deny,Allow@#  Order Deny,Allow@' > /etc/httpd/conf.d/phpmyadmin.conf
# rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

# mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
# cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@  Deny from all@#  Deny from all@' > /etc/httpd/conf.d/phpmyadmin.conf
# rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

# mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
# cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@  Allow from 127.0.0.1@#  Allow from 127.0.0.1@' > /etc/httpd/conf.d/phpmyadmin.conf
# rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

# mv /etc/httpd/conf.d/phpmyadmin.conf /etc/httpd/conf.d/phpmyadmin.conf.bkp
# cat /etc/httpd/conf.d/phpmyadmin.conf.bkp | sed -e 's@</Directory>@#</Directory>@' > /etc/httpd/conf.d/phpmyadmin.conf
# rm /etc/httpd/conf.d/phpmyadmin.conf.bkp

# mv /usr/share/phpmyadmin/config.inc.php /usr/share/phpmyadmin/config.inc.php.bkp
# cat /usr/share/phpmyadmin/config.inc.php.bkp | sed -e 's@cookie@http@' > /usr/share/phpmyadmin/config.inc.php
# rm /usr/share/phpmyadmin/config.inc.php.bkp

# # Get the latest version of phpMyAdmin
# mv -f /usr/share/phpmyadmin/config.inc.php /vagrant
# rm -rf /usr/share/phpmyadmin
# echo "Downloading phpmyadmin $phpmyadmin_version to replace old version from repo ..."
# wget --quiet "http://kent.dl.sourceforge.net/project/phpmyadmin/phpMyAdmin/$phpmyadmin_version/phpMyAdmin-$phpmyadmin_version-all-languages.tar.gz"
# tar xfz ./phpMyAdmin-$phpmyadmin_version-all-languages.tar.gz -C /usr/share/
# mv /usr/share/phpMyAdmin-$phpmyadmin_version-all-languages /usr/share/phpmyadmin
# mv -f /vagrant/config.inc.php /usr/share/phpmyadmin
# rm -f ./phpMyAdmin-$phpmyadmin_version-all-languages.tar.gz
# rm -f /vagrant/config.inc.php



update_installed 'mysql-dev'

phase_finish

exit 0
