#!/bin/bash

#
# Provisioning for deployment of server
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

#
# NANO
#
yum -y install nano

#
# Extra sintax highlightning
#
sudo cp templates/* /usr/share/nano

cat >> /etc/nanorc <<EOF

## Config Files (.ini)
include "/usr/share/nano/ini.nanorc"

## Xorg.conf
include "/usr/share/nano/xorg.nanorc"

## CSS
include "/usr/share/nano/css.nanorc"

## XML
include "/usr/share/nano/xml.nanorc"

## Generic .conf
include "/usr/share/nano/conf.nanorc"

## PHP
include "/usr/share/nano/php.nanorc"
EOF

