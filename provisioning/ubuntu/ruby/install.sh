#!/bin/bash

#
# Script for instalation of an application in a vagrant VBox with ubuntu
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

PHASE="ruby"

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

phase_start

echo "Installing ruby ... "
apt-get install -y ruby

echo
echo "Done"
echo

update_installed 'ruby'

phase_finish

exit 0