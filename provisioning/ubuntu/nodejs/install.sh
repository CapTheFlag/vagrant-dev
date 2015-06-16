#!/bin/bash

#
# Script for instalation of git in a vagrant VBox with ubuntu
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

PHASE="NODEJS"
DEPENDENCIES=(  )

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

echo
echo "Installing dependencies ... "
echo
install_apps DEPENDENCIES[@]


# install NodeJs
# from source it will give an error because its a pre-release
# git clone https://github.com/joyent/node.git
# cd node
# ./configure && make && make install
apt-get install nodejs npm
ln -sf /usr/bin/nodejs /usr/local/bin/node
ln -sf /usr/bin/npm /usr/local/bin/npm
node --version
npm --version

exit 0
