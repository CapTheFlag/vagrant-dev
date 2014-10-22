#!/bin/bash
#
# A hook to trigger a jenkins build when a specific branch is pushed to.
# If several branches are pushed, 'prd' and 'stg' are notified to jenkins
#
# To enable this hook, rename this file to "post-receive".
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0

USERNAME='videodock'
PASSWORD='videodock'

SCRIPT_DIR_PATH="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PARENT_DIR_PATH="$(dirname "${SCRIPT_DIR_PATH}")"
PARENT_DIR_NAME="$(basename "${PARENT_DIR_PATH}")"

# remove the git extension from the folder
PROJECT_NAME="${PARENT_DIR_NAME%.*}"

while read oldrev newrev refname; do
    BRANCH=$(git rev-parse --symbolic --abbrev-ref $refname)
    if [ "prd" == "$BRANCH" ] || [ "stg" == "$BRANCH" ]; then
        #HASH==$(${SCRIPT_DIR_PATH}/git rev-parse --verify HEAD)
        #CMD="/usr/bin/curl --user ${USERNAME}:${PASSWORD} -s http://cis.videodock.com:8080/jenkins/job/${PROJECT_NAME}/buildWithParameters?token=runforrestrun&BRANCH=${BRANCH}&HASH=${HASH}"
        CMD="/usr/bin/curl --user ${USERNAME}:${PASSWORD} -s \"http://cis.videodock.com:8080/jenkins/job/${PROJECT_NAME}/buildWithParameters?token=runforrestrun&BRANCH=${BRANCH}\"

        echo "["$(date +"%Y-%m-%d %T")"] " ${CMD} >> ~/notifications_from_git.log
        eval ${CMD} >> /home/git/notifications_from_git.log
    fi
done
