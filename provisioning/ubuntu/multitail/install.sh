#!/bin/bash

#
# Script for instalation of multitail in a vagrant VBox with ubuntu
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

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

echo
echo "Installing multitail... "
echo
apt-get -y install multitail

# ------------------------------------------------------------------

echo
echo "Setting up multitail ... "
echo
# making multitail not check emails
echo "check_mail:0" >> ~/.multitailrc
for HOME_DIR in `find /home -type d -maxdepth 0`; do
   echo "check_mail:0" >> $HOME_DIR/.multitailrc
done




update_installed 'multitail'

exit 0
