#!/bin/bash

#
# Script to setup the nfs caching
# This has to run on system cron:  @reboot  startnfscache
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. ${DIR}/../../settings.sh

cp -f /etc/mtab /etc/mtab.bkp
cat /etc/mtab.bkp | sed -e "s@nfs rw,vers@nfs rw,fsc,vers@" > /etc/mtab

mount -o remount 192.168.1.1:${HOST_PATH_TO_IDENV}/workspace/www

service cachefilesd restart