#!/bin/bash

#
# Script to restart the net 
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# sudo ifdown wlan0
# sudo ifup wlan0

sudo ifdown eth0
sudo ifup eth0

sudo service apache2 restart
sudo service php5-fpm restart

exit 0
