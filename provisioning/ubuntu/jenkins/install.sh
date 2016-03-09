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

PHASE="JENKINS"
DEPENDENCIES=( git multitail ant )

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

echo "Installing repo ... "
wget -q -O - http://pkg.jenkins-ci.org/debian/jenkins-ci.org.key | sudo apt-key add -
echo "deb http://pkg.jenkins-ci.org/debian binary/" >> /etc/apt/sources.list

echo "Updating apt-get ... "
apt-get update

echo "Installing jenkins ... "
apt-get install -y jenkins

echo
echo "Installing plugins ... "
echo

# trap the ERR signal to hook up our function
trap on_error ERR

# for some reason jenkins can not get the update information about plugins https://gist.github.com/rowan-m/1026918
# this fixes that issue
mkdir -p /var/lib/jenkins/updates
curl -L http://updates.jenkins-ci.org/update-center.json | sed '1d;$d' > /var/lib/jenkins/updates/default.json
chown -R jenkins:nogroup /var/lib/jenkins/updates
#---

service jenkins restart
sleep 60
if [ ! -f "/usr/bin/jenkins-cli" ]; then
    wget http://localhost:8080/jnlpJars/jenkins-cli.jar
    mv jenkins-cli.jar /usr/bin/jenkins-cli.jar
    chmod a+x /usr/bin/jenkins-cli.jar
fi
java -jar /usr/bin/jenkins-cli.jar -s http://localhost:8080 install-plugin groovy-postbuild git postbuild-task vagrant awseb-deployment-plugin ec2 ansicolor

java -jar /usr/bin/jenkins-cli.jar -s http://localhost:8080 safe-restart
sleep 60
# rm jenkins-cli.jar

echo
echo "Setting up jenkins group... "
echo
usermod -g jenkins jenkins
# TODO: add main user (videodock) to the jenkins group
#usermod -a -G jenkins videodock
#usermod -a -G videodock jenkins

update_installed 'jenkins'

phase_finish

exit 0