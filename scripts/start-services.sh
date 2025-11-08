#!/bin/bash

# Démarrer les services SSH
service ssh start

# Selon le rôle du conteneur
case $HADOOP_ROLE in
  "namenode")
    /scripts/init-hdfs.sh
    ;;
  "datanode")
    # Attendre le NameNode
    sleep 60
    ;;
esac

case $SPARK_ROLE in
  "master")
    # Démarrer Spark Master
    /spark/sbin/start-master.sh
    ;;
  "worker")
    # Démarrer Spark Worker
    /spark/sbin/start-worker.sh spark://master:7077
    ;;
esac

# Garder le conteneur actif
tail -f /dev/null