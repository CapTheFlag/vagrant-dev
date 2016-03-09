#!/bin/bash

#
# Provisioning for apache
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

# ==================================================================
#
# VARIABLES
#
# ------------------------------------------------------------------

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${DIR}/../settings.sh

# get environment from argument if it exist
if [ $# -ne 0 ]; then
    ENV=$1
fi

PHASE="NGNIX_STREAMING_CACHE"
DEPENDENCIES=(  )

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

phase_start

echo
echo "Installing dependencies ... "
echo
install_apps DEPENDENCIES[@]

if [ "${OS_VERSION}" == "14.04" ]; then
    apt-get install -y nginx
else
    echo "wrong version of Ubuntu! Exiting..."
    exit 1
fi

sudo mkdir /var/cache/nginx
sudo chown -R www-data:www-data /var/cache/nginx

sudo mkdir /var/log/nginx
sudo chown -R www-data:www-data /var/log/nginx

cat ${DIR}/templates/nginx.conf > /etc/nginx/nginx.conf

echo "127.0.0.1 edge.tst.video-dock.com" >> /etc/hosts

sudo service nginx restart

update_installed ${PHASE}

phase_finish

exit 0