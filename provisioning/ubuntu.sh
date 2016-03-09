#!/bin/bash

. ${ROOT_PROVISIONING}/settings.sh

DIST_UPGRADE=$1
HOSTNAME=$2
PROJECT_OS_DEPENDENCIES=$3

APPLICATIONS_DIR="${ROOT_PROVISIONING}/ubuntu"

APPLICATIONS=( ${PROJECT_OS_DEPENDENCIES} )

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

echo
echo "Updating repositories ... "
echo
# activate multiverse repos
sed -i "/^# deb.*multiverse/ s/^# //" /etc/apt/sources.list
apt-get update -y
if [ "${DIST_UPGRADE}" == "1" ]; then
    apt-get upgrade -y
fi

echo
echo "Installing applications ... "
echo
install_apps APPLICATIONS[@]

echo
echo "The provisioning has finished. "
echo
