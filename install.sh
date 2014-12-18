#!/bin/bash

if [ ! -d ./provisioning ]; then
    cp -Rf ./vendor/hgraca/vagrant-dev/dist ./provisioning
fi

ln -sf ./provisioning/vagrantfile.rb ./vagrantfile

