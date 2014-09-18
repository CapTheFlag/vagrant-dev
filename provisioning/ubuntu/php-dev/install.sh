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

PHASE="PHP-DEV"
DEPENDENCIES=( git multitail php composer )

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
echo "Installing PHP Development  Utilities... "
echo
apt-get -y install php5-xdebug

# ------------------------------------------------------------------

echo
echo "Configuring xDebug ... "
echo

if [ -d /etc/php5/mods-available ]; then
    # ubuntu > 1404
    CONFIG_FILE="/etc/php5/mods-available/xdebug.ini"
else
    CONFIG_FILE="/etc/php5/conf.d/xdebug.ini"
fi

XDEBUG_CONFIG="
xdebug.max_nesting_level=250
xdebug.remote_enable=1
xdebug.remote_host=193.168.1.1
xdebug.remote_connect_back=1
xdebug.remote_port=9000
xdebug.remote_handler=dbgp
xdebug.remote_mode=req
xdebug.profiler_enable=0
xdebug.profiler_output_dir=\"/var/www/profiler\"
xdebug.idekey=\"${XDEBUG_IDE_KEY}\""
echo "${XDEBUG_CONFIG}" >> ${CONFIG_FILE}
mkdir -p /var/www/profiler

# ------------------------------------------------------------------

echo
echo "Setting up environment variables ... "
echo
echo "export XDEBUG_CONFIG='${XDEBUG_CONFIG}'" >> /etc/bash.bashrc
export XDEBUG_CONFIG="${XDEBUG_CONFIG}"
echo "export PHP_IDE_CONFIG='serverName=${FULL_HOST_NAME}'" >> /etc/bash.bashrc
export PHP_IDE_CONFIG="serverName=${FULL_HOST_NAME}"

# ------------------------------------------------------------------

echo
echo "Installing phpunit ... "
echo
wget https://phar.phpunit.de/phpunit.phar &>> /dev/null
chmod +x phpunit.phar
mv phpunit.phar /usr/local/bin/phpunit

# ------------------------------------------------------------------

echo
echo "Installing phploc ... "
echo
wget https://phar.phpunit.de/phploc.phar &>> /dev/null
chmod +x phploc.phar
mv phploc.phar /usr/local/bin/phploc

# ------------------------------------------------------------------

echo
echo "Installing pdepend ... "
echo
wget http://static.pdepend.org/php/latest/pdepend.phar &>> /dev/null
chmod +x pdepend.phar
mv pdepend.phar /usr/local/bin/pdepend

# ------------------------------------------------------------------

echo
echo "Installing phpmd ... "
echo
wget http://static.phpmd.org/php/1.5.0/phpmd.phar &>> /dev/null
chmod +x phpmd.phar
mv phpmd.phar /usr/local/bin/phpmd

# ------------------------------------------------------------------

echo
echo "Installing phpcpd ... "
echo
wget https://phar.phpunit.de/phpcpd.phar &>> /dev/null
chmod +x phpcpd.phar
mv phpcpd.phar /usr/local/bin/phpcpd

# ------------------------------------------------------------------

echo
echo "Installing phpdox ... "
echo
wget http://phpdox.de/releases/phpdox.phar &>> /dev/null
chmod +x phpdox.phar
mv phpdox.phar /usr/local/bin/phpdox

# ------------------------------------------------------------------

echo
echo "Installing phpDocumentor ... "
echo
wget http://phpdoc.org/phpDocumentor.phar &>> /dev/null
chmod +x phpDocumentor.phar
mv phpDocumentor.phar /usr/local/bin/phpdoc

# ------------------------------------------------------------------

echo
echo "Installing codeception ... "
echo
wget http://codeception.com/codecept.phar &>> /dev/null
chmod +x codecept.phar
mv codecept.phar /usr/local/bin/codecept

# ------------------------------------------------------------------

echo
echo "Installing box tol to create phar files ... "
echo
curl -LSs http://box-project.org/installer.php | php
chmod +x box.phar
mv box.phar /usr/local/bin/box

# ------------------------------------------------------------------

echo
echo "Installing pear packages ... "
echo
pear config-set auto_discover 1
pear upgrade pear
pear channel-update pear.php.net
echo "Installing Var_Dump ... "
pear install Var_Dump
echo "Installing PHP_CodeSniffer ... "
pear install PHP_CodeSniffer

# ------------------------------------------------------------------

# echo
# echo "Copying www from host to guest ..."
# echo
# cp -fR /vagrant/workspace/www/* /var/www/

update_installed 'php-dev'

phase_finish

exit 0
