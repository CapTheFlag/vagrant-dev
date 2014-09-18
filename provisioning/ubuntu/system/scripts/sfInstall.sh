#!/bin/bash

#
# Script for instalation of symfony in a vagrant VBox with ubuntu
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
PROJECT_PATH=/var/www/symfony
PROJECT_NAME=symfony
ENVIRONMENT='dev'

. ${DIR}/../settings.sh

# get environment from argument if it exist
if [ $# -ne 0 ]; then
    ENV=$1
fi

# ==================================================================
#
# FUNCTIONS
#
# ------------------------------------------------------------------

fc_help(){
        echo -e "\033[33m Usage:  \033[0m"
        echo -e "\033[33m " $0 " [-h] -p <project_path> -n <project_name> -e <environment> \033[0m"
        echo -e "\033[33m Options: \033[0m"
        echo -e "\033[33m          -h   Show this help information. \033[0m"
        echo -e "\033[33m          -p   The project path [/var/www/symfony]. \033[0m"
        echo -e "\033[33m          -n   The project name [symfony]. \033[0m"
        echo -e "\033[33m          -e   The environment [dev]. \033[0m"
}

# ------------------------------------------------------------------

function fc_setVars(){

    # CMD options
    while getopts "hp:n:e:" opt; do
        case $opt in
            p)
                PROJECT_PATH=$OPTARG
                ;;

            n)
                PROJECT_NAME=$OPTARG
                ;;

            n)
                ENVIRONMENT=$OPTARG
                ;;

            h)
                fc_help
                exit 0
                ;;

            \?)
                echo "Invalid option: -$OPTARG" >&2
                echo
                fc_help
                exit 1
                ;;

        esac
    done

    shift $(($OPTIND - 1))

}

# ------------------------------------------------------------------

function fc_symfony_cache_setup() {

    # clean the cache and set the permissions
    ./sfClearCache.sh ${PROJECT_NAME}
}

# ------------------------------------------------------------------

function fc_install_acl() {
	INSTALLED=dpkg-query -l acl | grep | wc -l

	if [ $INSTALLED -eq 0 ]; then
		apt-get -y install acl
		cp /etc/fstab /etc/fstab.bkp
		cat /etc/fstab.bkp | sed -e "s@errors=remount-ro@acl,errors=remount-ro@" > /etc/fstab
		sudo mount -o remount /
	fi
}

# ------------------------------------------------------------------

function fc_install_intl() {
	INSTALLED=dpkg-query -l php5-intl | grep | wc -l

	if [ $INSTALLED -eq 0 ]; then
		apt-get -y install php5-intl
	fi
}

# ------------------------------------------------------------------

function fc_install_apc() {
	INSTALLED=dpkg-query -l apc | grep | wc -l

	if [ $INSTALLED -eq 0 ]; then
		apt-get -y install apc
	fi

	IS_CONFIGURED=tr -s ' ' '\n' < /etc/php5/conf.d/apc.ini | grep "apc.shm_size=64" | wc -l

	if [ $IS_CONFIGURED -eq 0 ]; then
		#If you have a newer version of PHP use an M or G after the apc.shm_size=64 ie apc.shm_size=64M or apc.shm_size=64G
		echo "apc.shm_size=64M" >> /etc/php5/conf.d/apc.ini
	fi

	if [ -f /var/www/apc.php ]; then
		wget -O /var/www/apc.php http://pecl.php.net/get/APC
	fi

}

# ------------------------------------------------------------------

function fc_config_php() {
	mv /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.bkp
	cat /etc/php5/apache2/php.ini.bkp | sed -e "s@^;date.timezone =@date.timezone = ${TZ}@" > /etc/php5/apache2/php.ini
	cp /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.bkp
	cat /etc/php5/apache2/php.ini.bkp | sed -e "s@^short_open_tag = On@short_open_tag = Off@" > /etc/php5/apache2/php.ini

	#Set "xdebug.max_nesting_level" to e.g. "250" in php.ini* to stop Xdebug's infinite recursion protection erroneously throwing a fatal error in your project.
	if [ -f /etc/php5/conf.d/xdebug.ini ]; then

		IS_CONFIGURED=tr -s ' ' '\n' < /etc/php5/conf.d/xdebug.ini | grep "xdebug.max_nesting_level=250" | wc -l

		if [ $IS_CONFIGURED -eq 0 ]; then
			echo "xdebug.max_nesting_level=250" >> /etc/php5/conf.d/xdebug.ini
		fi

	fi

}

# ------------------------------------------------------------------

function fc_set_umask() {
    # set umask in console
    cp ${PROJECT_PATH}/app/console ${PROJECT_PATH}/app/console.bkp
    cat ${PROJECT_PATH}/app/console.bkp | sed -e "s@<?php@<?php

if (getenv('APPLICATION_ENV') === 'dev_vagrant') {
    umask(0000);
}@" > ${PROJECT_PATH}/app/console

    # set umask in app.php
    cp ${PROJECT_PATH}/web/app.php ${PROJECT_PATH}/web/app.php.bkp
    cat ${PROJECT_PATH}/web/app.php.bkp | sed -e "s@<?php@<?php

if (getenv('APPLICATION_ENV') === 'dev_vagrant') {
    umask(0000);
}@" > ${PROJECT_PATH}/web/app.php

    # set umask in app_dev.php
    cp ${PROJECT_PATH}/web/app_dev.php ${PROJECT_PATH}/web/app_dev.php.bkp
    cat ${PROJECT_PATH}/web/app_dev.php.bkp | sed -e "s@<?php@<?php

if (getenv('APPLICATION_ENV') === 'dev_vagrant') {
    umask(0000);
}@" > ${PROJECT_PATH}/web/app_dev.php
}

# ------------------------------------------------------------------

function fc_install_dependencies() {
	# fc_install_acl
	fc_install_intl
	fc_config_php

    OS_VERSION=`lsb_release -sr`
    if [ $(echo "${OS_VERSION} < 13.10" | bc) -eq 1 ]; then
        fc_install_apc
    fi
}

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

fc_setVars "${@}"



# install
if [ ! -f /usr/bin/composer ]; then
    curl -sS https://getcomposer.org/installer | php -d detect_unicode=Off
    mv composer.phar /usr/bin/composer
fi
composer create-project symfony/framework-standard-edition ${PROJECT_PATH} 2.3.0



# setup

fc_set_umask

fc_symfony_cache_setup

fc_install_dependencies


echo
echo "Done"
echo
