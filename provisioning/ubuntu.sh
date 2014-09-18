#!/bin/bash

. ${VAGRANT_DEV_HOME}/provisioning/settings.sh

DIST_UPGRADE=$1
HOSTNAME=$2
PROJECT_OS_DEPENDENCIES=$3

APPLICATIONS_DIR="${VAGRANT_DEV_HOME}/provisioning/ubuntu"

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
