#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== START SOLR.SH =========="
echo

. /vagrant/config.sh

yum install -y java-$java_version-openjdk tomcat$tomcat_version

echo "downloading solr $solr_version ..."
wget -qO- "ftp://ftp.cs.uu.nl/mirror/apache.org/dist/lucene/solr/$solr_version/solr-$solr_version.tgz" | \
tar xzf -

echo "installing solr $solr_version ..."
mv solr-$solr_version /opt/solr-$solr_version
ln -s /opt/solr-$solr_version /opt/solr

echo "setting up dataImport script to be used by cron jobs for automatic update of solr cores..."
cp -f /vagrant/provisioning/templates/solr/dataImport.sh /opt/solr/
chmod a+x /opt/solr/dataImport.sh

echo "setting up a log libraries..."
cp /opt/solr/example/lib/ext/* /usr/share/java/tomcat6
cp /vagrant/provisioning/templates/solr/log4j.properties /usr/share/java/tomcat6


echo "setting up a default example instance1..."
cp -r /vagrant/provisioning/templates/solr/instances /opt/solr/
ln -s /opt/solr/instances/instance1.xml /usr/share/tomcat6/conf/Catalina/localhost/instance1.xml
chown tomcat:tomcat -R /opt/solr-$solr_version

service tomcat6 restart

echo "waiting for 2min for instance1 to be deployed by tomcat..."
sleep 120

#
# This is comented out because if we put passwords its dificult to access it from http, specially with jasper
#
# echo "setting up users for solr..."
# perl -i -pe 's@</tomcat-users>@
#     <role rolename="solrUser"/>
#     <user username="root" password="xpto" roles="solrUser"/>
#     <user username="reportsserver" password="xpto" roles="solrUser"/>
# </tomcat-users>@' /usr/share/tomcat6/conf/tomcat-users.xml

# echo "setting up authentication for instance1..."
# perl -i -pe 's@</web-app>@
#     <security-constraint>
#         <web-resource-collection>
#             <web-resource-name>SOLR - Instance 1</web-resource-name>
#             <url-pattern>/*</url-pattern>
#         </web-resource-collection>
#         <auth-constraint>
#             <role-name>solrUser</role-name>
#         </auth-constraint>
#     </security-constraint>
#     <login-config>
#         <auth-method>BASIC</auth-method>
#         <realm-name>SOLR - Instance 1</realm-name>
#     </login-config>
# </web-app>@' /var/lib/tomcat6/webapps/instance1/WEB-INF/web.xml

# service tomcat6 restart

echo
echo "========== FINISHED SOLR.SH =========="
echo
