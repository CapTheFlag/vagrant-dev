#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== START VARNISH.SH =========="
echo

. /vagrant/config.sh

echo "installing varnish repo..."
rpm --nosignature -i http://repo.varnish-cache.org/redhat/varnish-3.0/el5/noarch/varnish-release-3.0-1.noarch.rpm

echo "installing varnish ..."
yum install -y varnish

service varnish start

echo
echo "========== FINISHED VARNISH.SH =========="
echo
