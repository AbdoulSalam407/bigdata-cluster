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
