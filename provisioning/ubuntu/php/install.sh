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

PHASE="PHP"
DEPENDENCIES=( )

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
echo "Installing PHP ... "
echo
# php5-json    Needed for composer to install and work at least in version 13.10
# php5-xsl     Needed for phpdox, used to generate documentation 
# php5-suhosin Extra security
apt-get -y install php5 php5-common php5-cli php5-dev php-pear php5-mysql php5-intl php5-curl php5-json php5-xsl php5-memcache php5-memcached memcached
# php-xml php-pdo php-mbstring php-bcmath php-common php-soap php-gd php-imap php-ldap php-odbc php-xmlrpc

# extra packages from http://www.howtoforge.com/perfect-server-ubuntu-14.04-apache2-php-mysql-pureftpd-bind-dovecot-ispconfig-3-p4
# php5-gd php5-imap phpmyadmin php5-cgi php-pear php-auth php5-mcrypt mcrypt php5-imagick imagemagick libruby 
# php5-ming php5-ps php5-pspell php5-recode php5-snmp php5-sqlite php5-tidy php5-xmlrpc

if [ $(echo "${OS_VERSION} < 13.10" | bc) -eq 1 ]; then
    apt-get -y install php-apc
    echo
    echo "Configuring APC cache for php ... "
    echo
    #If you have a newer version of PHP use an M or G after the apc.shm_size=64 ie apc.shm_size=64M or apc.shm_size=64G
    echo "apc.shm_size=64M" >> /etc/php5/conf.d/apc.ini
    wget -O /var/www/apc.php http://pecl.php.net/get/APC
elif [ "${OS_VERSION}" == "14.04" ] || [ "${OS_VERSION}" == "17" ]; then
    apt-get -y install libapache2-mod-fastcgi php5-fpm

    echo '
<IfModule mod_fastcgi.c>
    AddHandler php5-fcgi .php
    Action php5-fcgi /php5-fcgi
    Alias /php5-fcgi /usr/lib/cgi-bin/php5-fcgi
    FastCgiExternalServer /usr/lib/cgi-bin/php5-fcgi -socket /var/run/php5-fpm.sock -pass-header Authorization
    <Directory /usr/lib/cgi-bin>
        Require all granted
    </Directory>
</IfModule>' > /etc/apache2/conf-available/php5-fpm.conf

    a2dismod php5
    a2enmod actions fastcgi alias
    a2enconf php5-fpm
    service apache2 reload

fi

# ------------------------------------------------------------------

echo
echo "Configuring PHP ... "
echo

CONTEXT_LIST=( cli apache2 fpm )
for CONTEXT in "${CONTEXT_LIST[@]}"; do
    if [ -d /etc/php5/${CONTEXT} ]; then
        replaceText /etc/php5/${CONTEXT}/php.ini "^;date.timezone =" "date.timezone = ${TIMEZONE}"
        replaceText /etc/php5/${CONTEXT}/php.ini "^short_open_tag = On" "short_open_tag = Off"
        replaceText /etc/php5/${CONTEXT}/php.ini "^;sendmail_path =" "sendmail_path = /usr/sbin/sendmail -t -i"
        replaceText /etc/php5/${CONTEXT}/php.ini "^memory_limit = 128M" "memory_limit = 512M"
        replaceText /etc/php5/${CONTEXT}/php.ini "^;phar.readonly = On" "phar.readonly = Off"
        replaceText /etc/php5/${CONTEXT}/php.ini "display_errors = Off" "display_errors = On"
        replaceText /etc/php5/${CONTEXT}/php.ini "error_reporting = E_ALL & ~E_DEPRECATED & ~E_STRICT" "error_reporting = E_ALL"
    fi
done

service apache2 restart
if [ -d /etc/php5/fpm ]; then
    service php5-fpm restart
fi

# ------------------------------------------------------------------

echo
echo "Installing pear packages ... "
echo
pear config-set auto_discover 1
pear upgrade pear
pear channel-update pear.php.net
echo
echo "Installing phing ... "
echo
# THIS DOES NOT WORK PROPERLY
# wget http://www.phing.info/get/phing-latest.phar
# chmod +x phing-latest.phar
# mv phing-latest.phar /usr/local/bin/phing

pear channel-discover pear.phing.info
pear config-set preferred_state alpha
pear install --alldeps phing/phingdocs
pear install --alldeps phing/phing
pear config-set preferred_state stable

# ------------------------------------------------------------------

echo
echo "Setting up environment variables ... "
echo
echo "export APPLICATION_ENV='${APPLICATION_ENV}'" >> /etc/bash.bashrc
export APPLICATION_ENV="${APPLICATION_ENV}" # so that after installing its imediatly available

# ------------------------------------------------------------------

update_installed 'php'

phase_finish

exit 0