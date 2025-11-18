Voici un **README.md complet**, professionnel, clair et parfait pour ton GitHub ou ton rendu en tant que consultant Big Data.
Il suit une structure standard utilisée dans les vrais projets en entreprise.

---

# ✅ **README.md — Cluster Big Data avec Docker**

*(Copie-colle directement dans ton fichier `README.md`)*

---

```md
# 🚀 Cluster Big Data avec Docker  
### Hadoop + Spark + Hive + PostgreSQL + Apache NiFi  
### Architecture : 1 Master + 2 Slaves

---

## 📌 1. Introduction

Ce projet met en place un **cluster Big Data complet** basé sur Docker, intégrant :

- **Hadoop (HDFS + YARN)** — Stockage distribué et exécution des jobs  
- **Spark** — Traitement distribué en mémoire  
- **Hive** — Entrepôt de données avec interface SQL  
- **Metastore PostgreSQL** — Métadonnées Hive  
- **Apache NiFi** — ETL et ingestion de données  
- **3 nœuds** : 1 Master + 2 Slaves

L’objectif est d’obtenir un environnement complet pour :
- Développement
- Formation / démonstration Big Data
- POC Data Engineering
- Ingestion → Stockage → Traitement → Consultation SQL

---

## 📂 2. Architecture du Cluster

```

```
                +------------------------+
                |       PostgreSQL        |
                |   Hive Metastore DB     |
                +------------+------------+
                             |
                 +-----------v-----------+
                 |     Hive Metastore    |
                 +-----------+-----------+
                             |
            +----------------+----------------+
            |                                 |
   +--------v--------+               +--------v--------+
   |     Master      |               |     Apache NiFi  |
   |------------------|               -------------------
   | Hadoop NameNode  |
   | YARN ResourceMgr |
   | Spark Master     |
   | HiveServer2      |
   +--------+---------+
            |
```

+-------------+----------------------------+
|                                          |
+---v---+                                 +---v---+
| Slave1|                                 | Slave2|
|-------|                                 |-------|
|DataNode|                                |DataNode|
|SparkWrk|                                |SparkWrk|
+-------+                                 +--------+

```

---

## 📁 3. Structure du Projet

```

bigdata-cluster/
│
├── docker-compose.yml
│
├── hadoop/
│   └── config/
│       ├── core-site.xml
│       ├── hdfs-site.xml
│       ├── yarn-site.xml
│       └── mapred-site.xml
│
├── hive/
│   └── config/
│       ├── hive-site.xml
│       └── metastore-site.xml
│
├── spark/
│   └── config/
│       └── spark-defaults.conf
│
├── nifi/
│   └── config/
│
└── README.md

````

---

## 🛠️ 4. Prérequis

- Docker Desktop ≥ 4.x
- Docker Compose ≥ v2
- 8 GB RAM minimum
- 20+ GB de stockage libre

---

## 🚀 5. Démarrage du Cluster

### Étape 1 — Formater le NameNode
(Docker oblige, première initialisation obligatoire)

```bash
docker-compose up -d master
docker exec -it master hdfs namenode -format -force
````

### Étape 2 — Démarrer tout le cluster

```bash
docker-compose up -d
```

---

## 🔍 6. Interfaces Web

| Service              | URL                                            |
| -------------------- | ---------------------------------------------- |
| Hadoop NameNode UI   | [http://localhost:9870](http://localhost:9870) |
| YARN ResourceManager | [http://localhost:8088](http://localhost:8088) |
| Spark Master UI      | [http://localhost:4040](http://localhost:4040) |
| HiveServer2          | JDBC Port 10000                                |
| NiFi Web UI          | [http://localhost:8080](http://localhost:8080) |

---

## 🧪 7. Vérifications & Tests

### ✔ Test HDFS

```bash
docker exec -it master hdfs dfs -ls /
docker exec -it master hdfs dfs -mkdir /user
```

### ✔ Test Spark

```bash
docker exec -it master spark-submit \
  --class org.apache.spark.examples.SparkPi \
  /spark/examples/jars/spark-examples*.jar 10
```

### ✔ Test Hive (avec Beeline)

```bash
docker exec -it master beeline -u jdbc:hive2://master:10000 \
  -n hive -p hive \
  -e "SHOW DATABASES;"
```

Créer une table :

```sql
CREATE TABLE test (id INT, name STRING);
```

### ✔ Test NiFi

* Accéder à **[http://localhost:8080](http://localhost:8080)**
* Importer un template
* Exécuter un flux (ex : ingest → HDFS → Hive)

---

## 🧱 8. Fonctionnement des Services

### 🔵 Master Node

* NameNode
* ResourceManager
* Spark Master
* HiveServer2

### 🔵 Slaves

* DataNode
* NodeManager
* Spark Worker

### 🔵 PostgreSQL

* Base de métadonnées Hive

### 🔵 Hive Metastore

* Service intermédiaire entre Hive et PostgreSQL

### 🔵 Apache NiFi

* Ingestion / ETL automatisée

---

## 🔧 9. Administration du Cluster

### Logs d’un service

```bash
docker logs master -f
```

### Redémarrer un service

```bash
docker-compose restart slave2
```

### Arrêter tout

```bash
docker-compose down
```

### Supprimer volumes (nettoyage complet)

```bash
docker-compose down -v
```

---

## 📌 10. Améliorations possibles

* Ajouter Kafka + Zookeeper
* Ajouter Airflow (orchestration)
* Intégrer Grafana + Prometheus pour monitoring
* Ajouter Superset ou Metabase pour BI
* Déployer sur Kubernetes (K8s)

---

## 📜 11. Licence

Libre d'utilisation pour l'éducation, la formation, la démonstration et les POC Data Engineering.

---

## ✨ 12. Auteur

Projet réalisé par **Abdoul Salam Diallo**
Étudiant M1 | Data Engineering | Big Data & Cloud Computing
UFR SET — Université Iba Der Thiam de Thiès

---

```

---

# 🎉 Si tu veux, je peux aussi te générer :

✅ un **schéma PNG** de l’architecture  
✅ un **README version professionnelle consultant (PDF)**  
✅ un **PowerPoint prêt à présenter le projet**  

Dis-moi ce que tu veux.
```
