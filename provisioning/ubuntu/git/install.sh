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

apt-get -y install git git-core git-gui git-cola

# ------------------------------------------------------------------

echo
echo "Setting up Git ... "
echo
git config --global user.name ${GIT_USER_NAME} # Sets the default name for git to use when you commit
git config --global user.email ${GIT_USER_EMAIL} # Sets the default email for git to use when you commit
git config --global core.editor ${GIT_CORE_EDITOR} # Sets the default editor
git config --global credential.helper 'cache --timeout=3600' # Set the cache to timeout after 1 hour (setting is in seconds)




exit 0


