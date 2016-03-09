#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== START VARNISH.VENDOR.SH =========="
echo

. /vagrant/config.sh

#
# Configuring varnish
#
echo "Copying varnish config files..."
cp -f /vagrant/provisioning/vendor/default/templates/varnish/default.vcl /etc/varnish/default.vcl
cp -f /vagrant/provisioning/vendor/default/templates/varnish/varnish /etc/sysconfig/varnish

perl -i -pe 's@        set beresp.ttl = 120 s;@        set beresp.ttl = '$cache_time' s;@' /etc/varnish/default.vcl

service varnish restart

echo
echo "========== FINISHED VARNISH.VENDOR.SH =========="
echo
