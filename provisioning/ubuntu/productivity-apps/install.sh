#!/bin/bash

#
# Script for instalation of productivity apps in a vagrant VBox with ubuntu
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
echo "Installing PHP Storm... "
echo
echo "downloading phpstorm ..."
# This can also be used to upgrade PHP Storm
wget --quiet http://download-ln.jetbrains.com/webide/PhpStorm-${PHPSTORM_VERSION[0]}.tar.gz
tar xvf ./PhpStorm-${PHPSTORM_VERSION[0]}.tar.gz -C /opt/
mv /opt/PhpStorm-${PHPSTORM_VERSION[1]} /opt/PhpStorm-${PHPSTORM_VERSION[0]}
rm -f /opt/PhpStorm
ln -sf /opt/PhpStorm-${PHPSTORM_VERSION[0]} /opt/PhpStorm
ln -sf /opt/PhpStorm/bin/phpstorm.sh /usr/bin/phpstorm

cp -f /opt/PhpStorm/bin/phpstorm64.vmoptions /home/herberto/.WebIde${PHPSTORM_VERSION[2]}/phpstorm64.vmoptions

# Optimization for faster rendering
echo "
-Dawt.useSystemAAFontSettings=lcd
-Dawt.java2d.opengl=true
" >> /home/herberto/.WebIde${PHPSTORM_VERSION[2]}/phpstorm64.vmoptions

# Optimization for more memory
echo "
-Xmx2048m
" >> /home/herberto/.WebIde${PHPSTORM_VERSION[2]}/phpstorm64.vmoptions

# ------------------------------------------------------------------

#echo
#echo "Installing f.lux, a multi-platform tool which adjusts the tint of your screen as night approaches to be more yellowy, removing the white/blue glare.  THIS DIDNT WORK VERY WELL !!"
#echo
#sudo add-apt-repository ppa:kilian/f.lux
#sudo apt-get update
#sudo apt-get install fluxgui

# ------------------------------------------------------------------

