#!/bin/bash

#
# Provisioning for system utilities
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

PHASE="TOGGL"
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

apt-get install -y libjpeg62 libxss1

echo
echo "Downloading toggl ..."
echo
wget -O /opt/toggl.tgz --quiet "https://toggl.com/api/v8/installer?app=td&platform=linux&channel=stable"
echo
echo "Installing AWS-CLI ..."
echo
cd /opt
tar zxvf toggl.tgz

# still need to add the chortcut in the menu

update_installed 'toggl'

phase_finish

exit 0
