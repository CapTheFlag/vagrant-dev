#!/bin/bash

#
# Configure mysql servers in a master-master-slave structure
#
# If IP ends with 1 or 2 its setup like a master, otherwise it will be a slave
#
# @author Herberto Graca <herberto.graca@gmail.com>
#
# Version: 1.0.0
echo
echo "========== START MYSQL_STRUCTURE.SH =========="
echo

. /vagrant/config.sh

echo "Getting last IP digit ..."
ip=`ifconfig eth1 | grep 'inet addr:' | cut -d: -f2 | awk '{print $1}'`
selfId=`echo ${ip:${#ip}-1}`
echo "Last IP digit: $selfId"

if [ "$selfId" == "1" ] || [ "$selfId" == "2" ]; then
    # set master

    if [ "$selfId" == "1" ]; then
        brotherId=2
    else
        brotherId=1
    fi

    echo "BrotherId: $brotherId"


    echo "Setting slave config in /etc/my.cnf ..."
    master_config="[mysqld]

    # primary master server id
    server-id=$selfId
    auto_increment_offset=$selfId

    # total number of master servers
    auto_increment_increment=2

    # local slave replication options
    log-bin=master$selfId-bin
    log-slave-updates

    "
    perl -i -pe "s@\[mysqld\]@$master_config@" /etc/my.cnf

    echo "Restarting server so configs are set in efect..."
    service mysqld restart


    if [ "$selfId" == "2" ]; then
        echo "Setting connections between masters ..."

        SMS=/tmp/show_master_status.txt

        echo "Geting brother info ..."
        mysql -h db$brotherId.$hostname_ext -u vagrant -pvagrant -ANe "SHOW MASTER STATUS" > ${SMS}
        CURRENT_LOG=`cat ${SMS} | awk '{print $1}'`
        CURRENT_POS=`cat ${SMS} | awk '{print $2}'`

        echo "Seting brother info in self ..."
        echo "mysql -u vagrant -pvagrant -e \"CHANGE MASTER TO MASTER_HOST='db$brotherId.$hostname_ext', MASTER_USER='$mysql_replication_user', MASTER_PASSWORD='$mysql_replication_pass', MASTER_LOG_FILE='$CURRENT_LOG', MASTER_LOG_POS=$CURRENT_POS;\""
        mysql -u vagrant -pvagrant -e "CHANGE MASTER TO MASTER_HOST='db$brotherId.$hostname_ext', MASTER_USER='$mysql_replication_user', MASTER_PASSWORD='$mysql_replication_pass', MASTER_LOG_FILE='$CURRENT_LOG', MASTER_LOG_POS=$CURRENT_POS;"

        echo "Geting self info ..."
        mysql -u vagrant -pvagrant -ANe "SHOW MASTER STATUS" > ${SMS}
        CURRENT_LOG=`cat ${SMS} | awk '{print $1}'`
        CURRENT_POS=`cat ${SMS} | awk '{print $2}'`

        echo "Seting self info in brother ..."
        echo "mysql -h db$brotherId.$hostname_ext -u vagrant -pvagrant -e \"CHANGE MASTER TO MASTER_HOST='db$selfId.$hostname_ext', MASTER_USER='$mysql_replication_user', MASTER_PASSWORD='$mysql_replication_pass', MASTER_LOG_FILE='$CURRENT_LOG', MASTER_LOG_POS=$CURRENT_POS;\""
        mysql -h db$brotherId.$hostname_ext -u vagrant -pvagrant -e "CHANGE MASTER TO MASTER_HOST='db$selfId.$hostname_ext', MASTER_USER='$mysql_replication_user', MASTER_PASSWORD='$mysql_replication_pass', MASTER_LOG_FILE='$CURRENT_LOG', MASTER_LOG_POS=$CURRENT_POS;"

        echo "Starting slave threads ..."
        mysql -h db$brotherId.$hostname_ext -u vagrant -pvagrant -e "START SLAVE;"
        mysql -u vagrant -pvagrant -e "START SLAVE;"

    fi

else
    # set slave
    # slaves will be distributed among the 2 masters

    rem=$(( $selfId % 2 ))
    if [ $rem -eq 0 ]; then
        masterId=2
    else
        masterId=1
    fi

    echo "Setting slave config in /etc/my.cnf ..."
    slave_config="[mysqld]

    # this slave's server-id
    server-id=$selfId

    "
    perl -i -pe "s@\[mysqld\]@$slave_config@" /etc/my.cnf

    echo "Restarting server so configs are set in efect..."
    service mysqld restart

    SMS=/tmp/show_master_status.txt

    echo "Geting master info ..."
    mysql -h db$masterId.$hostname_ext -u vagrant -pvagrant -ANe "SHOW MASTER STATUS" > ${SMS}
    CURRENT_LOG=`cat ${SMS} | awk '{print $1}'`
    CURRENT_POS=`cat ${SMS} | awk '{print $2}'`

    echo "Seting master info in self ..."
    echo "mysql -u vagrant -pvagrant -e \"CHANGE MASTER TO MASTER_HOST='db$masterId.$hostname_ext', MASTER_USER='$mysql_replication_user', MASTER_PASSWORD='$mysql_replication_pass', MASTER_LOG_FILE='$CURRENT_LOG', MASTER_LOG_POS=$CURRENT_POS;\""
    mysql -u vagrant -pvagrant -e "CHANGE MASTER TO MASTER_HOST='db$masterId.$hostname_ext', MASTER_USER='$mysql_replication_user', MASTER_PASSWORD='$mysql_replication_pass', MASTER_LOG_FILE='$CURRENT_LOG', MASTER_LOG_POS=$CURRENT_POS;"

    echo "Starting slave thread ..."
    mysql -u vagrant -pvagrant -e "START SLAVE;"

fi

echo
echo "========== FINISHED MYSQL_STRUCTURE.SH =========="
echo
