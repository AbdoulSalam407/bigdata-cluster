#!/bin/bash
echo "📁 Initialisation de HDFS..."
docker exec namenode hdfs dfs -mkdir -p /tmp
docker exec namenode hdfs dfs -mkdir -p /user/hive/warehouse
docker exec namenode hdfs dfs -chmod -R 777 /tmp
docker exec namenode hdfs dfs -chmod -R 777 /user/hive/warehouse
echo "✅ HDFS initialisé"