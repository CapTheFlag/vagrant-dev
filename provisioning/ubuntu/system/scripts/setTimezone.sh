#!/bin/bash
#
# Script that sets the timezone
#

TIME_ZONE=$1

echo $TIME_ZONE > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

sudo ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

echo "export TZ=${TIME_ZONE}" >> /etc/bash.bashrc
export TZ=${TIME_ZONE}
