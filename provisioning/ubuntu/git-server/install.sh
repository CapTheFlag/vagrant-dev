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

DEPENDENCIES=( git )

# ==================================================================
#
# MAIN
#
# ------------------------------------------------------------------


echo
echo "Installing dependencies ... "
echo
install_apps DEPENDENCIES[@]

apt-get -y install ssh

adduser --disabled-password --gecos "" git

echo '/usr/bin/git-shell' >> /etc/shells
mkdir /home/git/git-shell-commands
chmod 755 /home/git/git-shell-commands

# Extra security, however it gives very limited access. IE I could not create a repo with this shell.
#chsh -s /usr/bin/git-shell git

mkdir -p /home/git/.ssh
FILES="${ROOT_PROVISIONING}/git-server/pub_ssh_keys/*"
for file in $FILES
do
  cat $file >> /home/git/.ssh/authorized_keys
done
chown -R git:git /home/git/
chmod -R 600 /home/git/.ssh

echo "The git server has been created."
echo "To be able push to a repo, first you have to create it like: ssh git@IPADDRESS 'git init --bare example.git'"
echo "You also need to add the ssh public keys to the git user ~/.ssh/authorized_keys"
echo "Then you add this remote like: git remote add remotename git://IPADDRESS"
echo "Then you can push to it like: git push remotename destination-branch-name"



exit 0


