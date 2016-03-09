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

PHASE="sails-js"

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------

phase_start

echo "Installing ${PHASE} ... "

# update the whole server
apt-get upgrade && apt-get dist-upgrade && apt-get update && apt-get autoclean

# install dependent tools
apt-get install build-essential git

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

# install Sails-Js
npm -g install sails
sails --version

# install our app
cd ../
mkdir -p www
cd www
git clone ssh://sls@slsapp.com:1234/videodock/phenicx.git phenicx-nodejs
cd phenicx-nodejs
git checkout mobile-app-backend-prd
npm install

#start sails
sails lift

# install forever
npm -g install forever
# forever start -ae errors.log -w app.js --dev --port 1337
forever start -ae errors.log -w app.js --prod --port 1337

echo
echo "Done"
echo

update_installed ${PHASE}

phase_finish

exit 0