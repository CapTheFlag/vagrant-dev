#!/bin/bash

#
# Provisioning settings specific to ubuntu
# This file is imported to all installation scripts
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

SETTINGS_DIR_3="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

. ${SETTINGS_DIR_3}/../settings.sh

APPLICATIONS_DIR=${SETTINGS_DIR_3}
