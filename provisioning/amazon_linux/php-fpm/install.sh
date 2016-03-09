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

PHASE="PHP-FPM"
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
echo "Installing ... "
echo
yum -y update

# Install pre-req
#yum --enablerepo=epel install -y make libtool httpd-devel apr-devel apr 
yum --enablerepo=epel install -y make libtool apr-devel apr 

# Install Apache and PHP-FPM
#yum --enablerepo=epel install -y httpd php-fpm php-cli
yum --enablerepo=epel install -y php-fpm 

yum install -y gcc make php-fpm php-devel php-mysql php-pdo php-pear php-mbstring php-cli php-odbc php-xml


# Install mod_fastcgi
mkdir /root/files ; cd /root/files
wget http://www.fastcgi.com/dist/mod_fastcgi-current.tar.gz
tar -zxvf mod_fastcgi-current.tar.gz
cd mod_fastcgi-2.4.6/
cp Makefile.AP2 Makefile
make top_dir=/usr/lib/httpd
make install top_dir=/usr/lib/httpd

# Setup fastcgi folder
mkdir /var/www/fcgi-bin
cp $(which php-cgi) /var/www/fcgi-bin/
chown -R apache: /var/www/fcgi-bin
chmod -R 755 /var/www/fcgi-bin

# Load the module and setup php handler in /etc/httpd/conf.d/php-fpm.conf

echo 'LoadModule fastcgi_module modules/mod_fastcgi.so
LoadModule actions_module modules/mod_actions.so
 
<IfModule mod_fastcgi.c>
        ScriptAlias /fcgi-bin/ "/var/www/fcgi-bin/"
        FastCGIExternalServer /var/www/fcgi-bin/php-cgi -host 127.0.0.1:9000 -pass-header Authorization
        AddHandler php-fastcgi .php
        Action php-fastcgi /fcgi-bin/php-cgi
</IfModule>' > /etc/httpd/conf.d/php-fpm.conf

# Start the servers
chkconfig php-fpm on
chkconfig httpd on
service php-fpm start
service httpd start

# ------------------------------------------------------------------

update_installed 'php'

phase_finish

exit 0