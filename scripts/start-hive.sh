#!/bin/bash

echo "🕒 Attente de HDFS et PostgreSQL..."
while ! nc -z namenode 9000; do 
  echo "⏳ En attente de HDFS..."
  sleep 5
done

while ! nc -z postgres 5432; do 
  echo "⏳ En attente de Postgres..."
  sleep 5
done

echo "✅ HDFS et Postgres prêts."

echo "🔧 Initialisation du schéma Hive..."
/opt/hive/bin/schematool -dbType postgres -initSchema -verbose

if [ $? -eq 0 ]; then
  echo "✅ Schéma Hive initialisé avec succès"
else
  echo "ℹ️  Schéma peut-être déjà initialisé"
fi

echo "🚀 Démarrage du Metastore Hive..."
nohup /opt/hive/bin/hive --service metastore > /var/log/hive-metastore.log 2>&1 &

echo "⏳ Attente du démarrage du Metastore..."
sleep 20

echo "🚀 Démarrage de HiveServer2..."
exec /opt/hive/bin/hiveserver2 --hiveconf hive.root.logger=INFO,console