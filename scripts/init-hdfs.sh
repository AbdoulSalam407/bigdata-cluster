#!/bin/bash

# Attendre que le NameNode soit démarré
sleep 30

# Formater HDFS
hdfs namenode -format -force

# Démarrer HDFS
start-dfs.sh

# Créer les répertoires HDFS nécessaires
hdfs dfs -mkdir -p /tmp
hdfs dfs -mkdir -p /user/hive/warehouse
hdfs dfs -mkdir -p /spark-logs
hdfs dfs -chmod -R 1777 /tmp
hdfs dfs -chmod -R 1777 /user/hive/warehouse

# Initialiser le schéma Hive
schematool -initSchema -dbType postgres

# Démarrer Hive Metastore
hive --service metastore &

# Démarrer HiveServer2
hiveserver2 &