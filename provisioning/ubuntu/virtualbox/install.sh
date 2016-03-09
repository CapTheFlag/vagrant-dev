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

PHASE="VIRTUALBOX"
DEPENDENCIES=( curl )

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
echo "Installing virtualbox ... "
echo
case  ${OS_VERSION}  in
    '12.04')
        DEB_URL='http://download.virtualbox.org/virtualbox/4.3.2/virtualbox-4.3_4.3.2-90405~Ubuntu~precise_amd64.deb'
        ;;
    '12.10')
        DEB_URL='http://download.virtualbox.org/virtualbox/4.3.2/virtualbox-4.3_4.3.2-90405~Ubuntu~quantal_amd64.deb'
        ;;
    *)
        DEB_URL='http://download.virtualbox.org/virtualbox/4.3.2/virtualbox-4.3_4.3.2-90405~Ubuntu~raring_amd64.deb'
        ;;
esac
wget ${DEB_URL}
FILE_NAME=`basename ${DEB_URL}`
dpkg -i ${FILE_NAME}
rm ${FILE_NAME}


update_installed 'virtualbox'

phase_finish

exit 0
