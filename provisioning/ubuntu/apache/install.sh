#!/bin/bash

#
# Provisioning for apache
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

if [ "${OS_VERSION}" == "14.04" ]; then
    apt-get -y install apache2 apache2-doc apache2-utils apache2-suexec libapache2-mod-php5 libapache2-mod-fastcgi libapache2-mod-suphp libapache2-mod-python
    # setup suphp
    cp -f ${DIR}/templates/suphp.conf /etc/apache2/mods-available/suphp.conf
    # activate fastcgi module
    a2enmod actions fastcgi alias
else
    apt-get -y install apache2 apache2-doc apache2-utils
fi

mkdir -p ${PROJECT_PATH}
if [ ! -f "${ROOT_PROVISIONING}/apache/${PROJECT_NAME}.dev.conf" ]; then
    log error "The apache config file was not found in '${ROOT_PROVISIONING}/apache/${PROJECT_NAME}.dev.conf'. The link to it will be created so you just need to add the file and restart apache."
fi
ln -sf ${ROOT_PROVISIONING}/apache/${PROJECT_NAME}.dev.conf /etc/apache2/sites-enabled/${PROJECT_NAME}.dev.conf


# hardcode env variables so we can restart apache when vagrant mounts /vagrant
# I DONT REMEMBER WHY THIS IS NEEDED AND ITS GIVING PROBLEMS, SO I TAKE IT OUT
# replaceText /etc/apache2/apache2.conf "User ${APACHE_RUN_USER}" "User www-data"
# replaceText /etc/apache2/apache2.conf "Group ${APACHE_RUN_GROUP}" "Group www-data"

# so theres no warning when starting apache
echo "

ServerName ${FULL_HOST_NAME}" >> /etc/apache2/apache2.conf


if [ "1" == "${IN_VAGRANT_BOX}" ]; then

    # we need to start apache after vagrant mounts the share
    cp -f ${DIR}/templates/apache_start_on_vagrant_mount.upstart.conf /etc/init/apache_start_on_vagrant_mount.upstart.conf
    # ------------------------------------------------------------------
    echo
    echo "Adding vagrant to apache group ... "
    echo
    usermod -G www-data vagrant
    # ------------------------------------------------------------------
    ln -sf ${ROOT_PROVISIONING}/apache/silex-boilerplate.dev.conf /etc/apache2/sites-enabled/silex-boilerplate.dev.conf

else

    update-rc.d apache2 disable
    # to reverse:
    # update-rc.d apache2 enable

fi

# TODO: add main user (videodock) to the apache group
#usermod -a -G www-data videodock
#usermod -a -G videodock www-data

a2enmod rewrite
a2enmod headers
service apache2 restart



exit 0
