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






yum -y update

yum install -y nginx

cat ${DIR}/templates/nginx.conf > /etc/nginx/nginx.conf

service nginx restart







update_installed ${PHASE}

phase_finish

exit 0