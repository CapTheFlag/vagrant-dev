#!/bin/bash

#
# Script for instalation of php in a vagrant VBox with ubuntu
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

PHASE="USP_SMOOTH_STREAMING"
DEPENDENCIES=( usp_mp4split )

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

echo
echo "Installing ... "
echo
rpm -ivh mod_smooth_streaming-1.6.6-amli-201309.x86_64.rpm

# ------------------------------------------------------------------

update_installed 'USP_SMOOTH_STREAMING'

phase_finish

exit 0