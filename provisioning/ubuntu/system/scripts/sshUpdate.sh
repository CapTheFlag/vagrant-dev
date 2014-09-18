#!/bin/bash

#
# Script replace the ssh keys on the guest with the ones on the provisioning scripts
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

rm -f /home/vagrant/.ssh/*

# default ssh files
cp -f ${VAGRANT_DEV_HOME}/provisioning/ubuntu/system/templates/ssh/* /home/vagrant/.ssh/

# custom ssh files
if [ -d /vagrant/provisioning/system/ssh-no-vcs ]; then
    cp -f /vagrant/provisioning/system/ssh-no-vcs/* /home/vagrant/.ssh/
fi

chmod 644 /home/vagrant/.ssh/*

chown vagrant:vagrant /home/vagrant/.ssh/*

