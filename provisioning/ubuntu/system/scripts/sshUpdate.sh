#!/bin/bash

#
# Script replace the ssh keys on the guest with the ones on the provisioning scripts
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

rm -f /home/vagrant/.ssh/*

if [ -d ${VAGRANT_DEV_HOME}/provisioning/ubuntu/system/templates/ssh-no-vcs ]; then
    cp -f ${VAGRANT_DEV_HOME}/provisioning/ubuntu/system/templates/ssh-no-vcs/* /home/vagrant/.ssh/
fi

cp -f ${VAGRANT_DEV_HOME}/provisioning/ubuntu/system/templates/ssh/* /home/vagrant/.ssh/

if [ -f ${VAGRANT_DEV_HOME}/provisioning/ubuntu/system/templates/ssh-no-vcs/config ]; then
    cp -f ${VAGRANT_DEV_HOME}/provisioning/ubuntu/system/templates/ssh-no-vcs/config /home/vagrant/.ssh/config
fi

chmod 644 /home/vagrant/.ssh/*

chown vagrant:vagrant /home/vagrant/.ssh/*

