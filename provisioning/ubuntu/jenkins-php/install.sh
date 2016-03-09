#!/bin/bash

#
# Script for instalation of jenkins CI in a vagrant VBox with ubuntu
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

PHASE="JENKINS-PHP"
DEPENDENCIES=( php-dev jenkins )

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
echo "Installing plugins for PHP ... "
echo

# trap the ERR signal to hook up our function
trap on_error ERR

if [ ! -f "./jenkins-cli.jar" ]; then
    wget http://localhost:8080/jnlpJars/jenkins-cli.jar
fi

java -jar /usr/bin/jenkins-cli.jar -s http://localhost:8080 install-plugin checkstyle cloverphp dry htmlpublisher jdepend plot pmd violations xunit phing

echo
echo "Installing template for PHP builds ... "
echo
curl https://raw.github.com/sebastianbergmann/php-jenkins-template/master/config.xml | java -jar jenkins-cli.jar -s http://localhost:8080 create-job php-template

#java -jar /usr/bin/jenkins-cli.jar -s http://localhost:8080 safe-restart
# rm jenkins-cli.jar


service jenkins stop

echo
echo "Setting up jenkins group... "
echo
usermod -a -G www-data jenkins
usermod -a -G jenkins www-data

echo
echo "Setting up the user jenkins will run as (www-data)... "
echo
replaceText /etc/default/jenkins 'JENKINS_USER=jenkins' 'JENKINS_USER=www-data'
replaceText /etc/init.d/jenkins 'DAEMON_ARGS="--name=$NAME' 'DAEMON_ARGS="--name=$JENKINS_USER'
chown -R www-data /var/log/jenkins
chown -R www-data /var/lib/jenkins
chown -R www-data /var/run/jenkins
chown -R www-data /var/cache/jenkins

service jenkins start

#sleep 60

update_installed 'jenkins-php'

phase_finish

exit 0