#!/bin/bash

#
# Alias for mp4split that adds the license key
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 2.0.0

DIR='/opt/mp4split'

TS=`date +%Y.%m.%d-%H.%M`
echo "[${TS}]  mp4split $@ " >> /var/log/mp4split.log

LICENSE_KEY=`cat ${DIR}/mp4split.key`

${DIR}/mp4split.exe --license-key=$LICENSE_KEY $@ 2>&1 | tee -a /var/log/mp4split.log
