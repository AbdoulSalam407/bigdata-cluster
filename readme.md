docker ps

# 1️⃣ Supprimer les anciens conteneurs interrompus

docker-compose down

# 2️⃣ Supprimer les anciennes images partielles

docker image prune -a -f

# 3️⃣ Relancer le cluster

docker-compose up -d

docker pull bde2020/hadoop-namenode

# 🧠 Projet Big Data Cluster avec Docker

## Hadoop | Spark | Hive | PostgreSQL | Apache NiFi

---

## 🏗️ Introduction

Dans le cadre de mon apprentissage en **Ingénierie des Données**, j’ai mis en place un **cluster Big Data** complet basé sur **Docker**.  
L’objectif est de **simuler un environnement distribué** similaire à un cluster de production, permettant le **stockage, le traitement et l’analyse de grandes volumétries de données**.

Ce cluster comprend :

- **Hadoop (HDFS)** pour le stockage distribué des données.
- **Apache Spark** pour le calcul et le traitement en parallèle.
- **Apache Hive** pour l’interrogation SQL des données sur HDFS.
- **PostgreSQL** servant de base de métadonnées pour Hive.
- **Apache NiFi** pour l’ingestion et l’orchestration des flux de données.

---

## 🎯 Objectifs du projet

- Mettre en place un **cluster Big Data multi-nœuds** (1 master, 2 slaves) via **Docker Compose**.
- Intégrer les **composants essentiels de l’écosystème Hadoop** (HDFS, Hive, Spark).
- Automatiser le déploiement et la configuration des services.
- Faciliter la création d’un **pipeline de données complet** : ingestion → stockage → traitement → visualisation.

---

## 🧩 Architecture globale

### 🔹 Vue d’ensemble du cluster

                 +-----------------------------+
                 |        Master Node          |
                 |-----------------------------|
                 |  Hadoop NameNode            |
                 |  Spark Master               |
                 |  Hive + PostgreSQL Metastore|
                 |  Apache NiFi                |
                 +-----------------------------+
                           |
       -------------------------------------------------
       |                                               |
        +--------------------+ +--------------------+
        | DataNode 1 | | DataNode 2 |
        |--------------------| |--------------------|
        | Hadoop Datanode | | Hadoop Datanode |
        | Spark Worker | | Spark Worker |
        +--------------------+ +--------------------+

---

## ⚙️ Technologies utilisées

| Outil              | Rôle                 | Description                                                                                    |
| ------------------ | -------------------- | ---------------------------------------------------------------------------------------------- |
| **Hadoop (HDFS)**  | Stockage distribué   | Découpe et répartit les fichiers sur plusieurs nœuds pour tolérance aux pannes et scalabilité. |
| **Spark**          | Traitement distribué | Exécute les calculs à grande échelle en mémoire, plus rapide que MapReduce.                    |
| **Hive**           | Interrogation SQL    | Fournit une interface SQL au-dessus d’HDFS pour manipuler les données facilement.              |
| **PostgreSQL**     | Métastore Hive       | Contient les métadonnées des tables Hive (schémas, partitions, etc.).                          |
| **NiFi**           | Ingestion de données | Permet de capturer, transformer et charger les données depuis diverses sources.                |
| **Docker Compose** | Orchestration        | Permet de lancer et connecter tous les services avec une seule commande.                       |

---

## 🧱 Structure du cluster Docker

### 📁 Arborescence du projet


 docker exec -it namenode bash

docker exec -it namenode bash
root@d0569a8c43eb:/# hdfs dfs -mkdir -p /data2/test
root@d0569a8c43eb:/# hdfs dfs -chown nifi:supergroup /data2/test
root@d0569a8c43eb:/# hdfs dfs -ls /data2
Found 1 items
drwxr-xr-x   - nifi supergroup          0 2025-11-08 11:49 /data2/test
root@d0569a8c43eb:/# hdfs dfs -ls /data2/test/temperatures
ls: `/data2/test/temperatures': No such file or directory
root@d0569a8c43eb:/# hdfs dfs -ls /data2/test
root@d0569a8c43eb:/# hdfs dfs -ls /data2/test
Found 1 items
drwxr-xr-x   - nifi supergroup          0 2025-11-08 12:02 /data2/test/temperatures
root@d0569a8c43eb:/# exit
exit


version: "3.9"

services:
  # =========================
  # 🗄️ Base de données PostgreSQL pour Hive Metastore
  # =========================
  postgres:
    image: postgres:15
    container_name: postgres
    environment:
      POSTGRES_USER: hive
      POSTGRES_PASSWORD: hive
      POSTGRES_DB: metastore
    ports:
      - "5432:5432"
    volumes:
      - ./data/postgres:/var/lib/postgresql/data
    networks:
      - bigdata-net

  # =========================
  # 🧱 Hadoop - NameNode
  # =========================
  namenode:
    image: bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8
    container_name: namenode
    environment:
      - CLUSTER_NAME=bigdata
    ports:
      - "8020:8020"
      - "9870:9870"
      - "9000:9000"
    volumes:
      - ./hadoop:/opt/hadoop/etc/hadoop
      - namenode:/hadoop/dfs/name
    env_file:
      - ./hadoop/hadoop.env
    networks:
      - bigdata-net

  # =========================
  # 🧱 Hadoop - DataNodes
  # =========================
  datanode1:
    image: bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
    container_name: datanode1
    environment:
      - CORE_CONF_fs_defaultFS=hdfs://namenode:9000
    ports:
      - "9864:9864"
    volumes:
      - datanode1:/hadoop/dfs/data
    networks:
      - bigdata-net
    depends_on:
      - namenode

  datanode2:
    image: bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
    container_name: datanode2
    environment:
      - CORE_CONF_fs_defaultFS=hdfs://namenode:9000
    ports:
      - "9865:9864"
    volumes:
      - datanode2:/hadoop/dfs/data
    networks:
      - bigdata-net
    depends_on:
      - namenode

  # =========================
  # ⚡ Spark Master
  # =========================
  spark:
    image: bde2020/spark-master:3.1.1-hadoop3.2
    container_name: spark
    environment:
      - SPARK_MODE=master
    ports:
      - "8080:8080"
      - "7077:7077"
    volumes:
      - ./spark:/spark/conf
    networks:
      - bigdata-net
    depends_on:
      - namenode
      - datanode1
      - datanode2

  # =========================
  # ⚡ Spark Worker
  # =========================
  spark-worker1:
    image: bde2020/spark-worker:3.1.1-hadoop3.2
    container_name: spark-worker1
    environment:
      - SPARK_MASTER=spark://spark:7077
    ports:
      - "8081:8081"
    networks:
      - bigdata-net
    depends_on:
      - spark

  # =========================
  # 🐝 Hive (Metastore + HiveServer2)
  # =========================
  hive:
    image: bde2020/hive:2.3.2-postgresql-metastore
    container_name: hive
    environment:
      HIVE_METASTORE_DB_HOST: postgres
      HIVE_METASTORE_DB_NAME: metastore
      HIVE_METASTORE_DB_USER: hive
      HIVE_METASTORE_DB_PASS: hive
      CORE_CONF_fs_defaultFS: hdfs://namenode:9000
    ports:
      - "10000:10000"
      - "10002:10002"
    depends_on:
      - namenode
      - datanode1
      - datanode2
      - postgres
    networks:
      - bigdata-net
    command: >
      bash -c "
        echo '🕒 Attente de HDFS et PostgreSQL...';
        until nc -z namenode 9000 && nc -z postgres 5432; do
          echo '⏳ En attente de HDFS ou Postgres...';
          sleep 5;
        done;
        echo '✅ HDFS et Postgres prêts.';

        echo '🔧 Initialisation du schéma Hive (si nécessaire)...';
        schematool -dbType postgres -initSchema || echo '✅ Schéma déjà initialisé.';

        echo '🚀 Démarrage du Metastore Hive...';
        nohup /opt/hive/bin/hive --service metastore > /var/log/metastore.log 2>&1 &

        echo '🚀 Démarrage de HiveServer2...';
        exec /opt/hive/bin/hive --service hiveserver2 --hiveconf hive.root.logger=INFO,console
      "

  # =========================
  # 🔄 Apache NiFi
  # =========================
  nifi:
    image: apache/nifi:1.27.0
    container_name: nifi
    ports:
      - "8089:8080"
    environment:
      - NIFI_WEB_HTTP_PORT=8080
    volumes:
      - ./data2:/data2
      - ./hadoop:/opt/hadoop/etc/hadoop
    networks:
      - bigdata-net
    depends_on:
      - hive
      - spark

# =========================
# 🔗 Réseau et volumes
# =========================
networks:
  bigdata-net:

volumes:
  namenode:
  datanode1:
  datanode2:




--------------------------------------------------------------------

















version: "3.9"

services:
  # =========================
  # 🗄️ Base de données PostgreSQL pour Hive Metastore
  # =========================
  postgres:
    image: postgres:15
    container_name: postgres
    environment:
      POSTGRES_USER: hive
      POSTGRES_PASSWORD: hive
      POSTGRES_DB: metastore
    ports:
      - "5432:5432"
    volumes:
      - ./data/postgres:/var/lib/postgresql/data
    networks:
      - bigdata-net
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U hive -d metastore"]
      interval: 10s
      timeout: 5s
      retries: 5

  # =========================
  # 🧱 Hadoop - NameNode
  # =========================
  namenode:
    image: bde2020/hadoop-namenode:2.0.0-hadoop3.2.1-java8
    container_name: namenode
    environment:
      - CLUSTER_NAME=bigdata
    ports:
      - "8020:8020"
      - "9870:9870"
      - "9000:9000"
    volumes:
      - ./hadoop:/opt/hadoop/etc/hadoop
      - namenode:/hadoop/dfs/name
    env_file:
      - ./hadoop/hadoop.env
    networks:
      - bigdata-net
    healthcheck:
      test: ["CMD", "hdfs", "dfsadmin", "-safemode", "get"]
      interval: 10s
      timeout: 10s
      retries: 10

  # =========================
  # 🧱 Hadoop - DataNodes
  # =========================
  datanode1:
    image: bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
    container_name: datanode1
    environment:
      - CORE_CONF_fs_defaultFS=hdfs://namenode:9000
    ports:
      - "9864:9864"
    volumes:
      - datanode1:/hadoop/dfs/data
    networks:
      - bigdata-net
    depends_on:
      - namenode

  datanode2:
    image: bde2020/hadoop-datanode:2.0.0-hadoop3.2.1-java8
    container_name: datanode2
    environment:
      - CORE_CONF_fs_defaultFS=hdfs://namenode:9000
    ports:
      - "9865:9864"
    volumes:
      - datanode2:/hadoop/dfs/data
    networks:
      - bigdata-net
    depends_on:
      - namenode

  # =========================
  # ⚡ Spark Master
  # =========================
  spark:
    image: bde2020/spark-master:3.1.1-hadoop3.2
    container_name: spark
    environment:
      - SPARK_MODE=master
    ports:
      - "8080:8080"
      - "7077:7077"
    volumes:
      - ./spark:/spark/conf
    networks:
      - bigdata-net
    depends_on:
      - namenode

  # =========================
  # ⚡ Spark Worker
  # =========================
  spark-worker1:
    image: bde2020/spark-worker:3.1.1-hadoop3.2
    container_name: spark-worker1
    environment:
      - SPARK_MASTER=spark://spark:7077
    ports:
      - "8081:8081"
    networks:
      - bigdata-net
    depends_on:
      - spark

  # =========================
  # 🐝 Hive (Metastore + HiveServer2)
  # =========================
  hive:
    image: bde2020/hive:2.3.2-postgresql-metastore
    container_name: hive
    environment:
      HIVE_METASTORE_DB_HOST: postgres
      HIVE_METASTORE_DB_NAME: metastore
      HIVE_METASTORE_DB_USER: hive
      HIVE_METASTORE_DB_PASS: hive
      CORE_CONF_fs_defaultFS: hdfs://namenode:9000
      HIVE_SITE_CONF_javax_jdo_option_ConnectionURL: jdbc:postgresql://postgres:5432/metastore
      HIVE_SITE_CONF_javax_jdo_option_ConnectionDriverName: org.postgresql.Driver
      HIVE_SITE_CONF_javax_jdo_option_ConnectionUserName: hive
      HIVE_SITE_CONF_javax_jdo_option_ConnectionPassword: hive
    ports:
      - "10000:10000"
      - "10002:10002"
      - "9083:9083"
    depends_on:
      postgres:
        condition: service_healthy
      namenode:
        condition: service_healthy
    networks:
      - bigdata-net
    volumes:
      - ./scripts:/scripts
    command: >
      bash -c "
        echo '🕒 Attente de HDFS et PostgreSQL...';
        until nc -z namenode 9000 && nc -z postgres 5432; do
          echo '⏳ En attente...';
          sleep 5;
        done;
        echo '✅ HDFS et Postgres prêts.';
        
        echo '🔧 Initialisation du schéma Hive...';
        /opt/hive/bin/schematool -dbType postgres -initSchema -verbose || echo 'ℹ️  Schéma peut-être déjà initialisé';
        
        echo '🚀 Démarrage du Metastore Hive en arrière-plan...';
        /opt/hive/bin/hive --service metastore &
        
        echo '⏳ Attente du démarrage du Metastore...';
        sleep 15;
        
        echo '🚀 Démarrage de HiveServer2...';
        exec /opt/hive/bin/hiveserver2
      "

  # =========================
  # 🔄 Apache NiFi
  # =========================
  nifi:
    image: apache/nifi:1.27.0
    container_name: nifi
    ports:
      - "8089:8080"
    environment:
      - NIFI_WEB_HTTP_PORT=8080
    volumes:
      - ./data2:/data2
      - ./hadoop:/opt/hadoop/etc/hadoop
    networks:
      - bigdata-net
    depends_on:
      - hive

networks:
  bigdata-net:

volumes:
  namenode:
  datanode1:
  datanode2:
