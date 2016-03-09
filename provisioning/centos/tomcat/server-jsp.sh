#!/bin/bash

#
# Provisioning for deployment of web server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== STARTED SERVER-JSP.SH =========="
echo

. /vagrant/config.sh

yum install -y liberation-sans-fonts java-$java_version-openjdk tomcat$tomcat_version
# installs to folder /usr/share/tomcat$tomcat_version

echo "Increase memory available so that solr and maily jasper don't have any memory problems ..."
cp /vagrant/provisioning/templates/tomcat/tomcat$tomcat_version.conf /etc/tomcat$tomcat_version/tomcat$tomcat_version.conf
chmod o+r /etc/tomcat$tomcat_version/tomcat$tomcat_version.conf

echo "Downloading mysql JDBC driver ..."
wget --quiet "http://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.25.tar.gz"
echo "Installing mysql JDBC driver ..."
tar xfz ./mysql-connector-java-5.1.25.tar.gz
mv ./mysql-connector-java-5.1.25/mysql-connector-java-5.1.25-bin.jar /usr/share/tomcat$tomcat_version/lib/mysql-connector-java-5.1.25-bin.jar
rm -Rf ./mysql-connector-java-5.1.25
rm -f ./mysql-connector-java-5.1.25.tar.gz
echo "Done"

chkconfig tomcat$tomcat_version on
service tomcat$tomcat_version restart

echo
echo "========== FINISHED SERVER-JSP.SH =========="
echo
