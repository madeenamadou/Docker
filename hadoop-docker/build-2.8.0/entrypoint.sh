#!/bin/sh

#  entrypoint.sh
#  
#
#  Created by Youssef de Madeen Amadou on 17-05-09.
#

: ${HADOOP_PREFIX:=/usr/local/hadoop}
$HADOOP_PREFIX/etc/hadoop/hadoop-env.sh

rm -rf /tmp/*.pid

# Configuration du nom d'hote
if [ -z $HADOOP_HOST_NAMENODE ]; then
export HADOOP_HOST_NAMENODE=$HOSTNAME;
fi

sed s/HOSTNAME/$HOSTNAME/ $HADOOP_PREFIX/etc/hadoop/core-site.xml.template > $HADOOP_PREFIX/etc/hadoop/core-site.xml

# Demarrage du cluster
systemctl enable sshd.service
$HADOOP_PREFIX/sbin/hadoop-daemon.sh start namenode
$HADOOP_PREFIX/sbin/hadoop-daemon.sh start datanode
$HADOOP_PREFIX/sbin/hadoop-daemon.sh start secondarynamenode
$HADOOP_PREFIX/sbin/yarn-daemon.sh start resourcemanager
$HADOOP_PREFIX/sbin/yarn-daemon.sh start nodemanager

# Dossier HDFS /user/root
if [[ -z `hdfs dfs -ls /` ]];then
hdfs dfs -mkdir -p /user/root/ && hdfs dfs -chmod g+w /user/root/;
fi

if [[ $1 == "-d" ]]; then
while true; do sleep 1; done
fi

if [[ $1 == "-bash" ]]; then
    /bin/bash
fi
