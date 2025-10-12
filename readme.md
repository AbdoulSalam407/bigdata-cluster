bigdata-cluster/
├── docker-compose.yml
├── hadoop/
│   ├── core-site.xml
│   ├── hdfs-site.xml
│   ├── yarn-site.xml
│   ├── mapred-site.xml
├── hive/
│   ├── hive-site.xml
├── spark/
│   ├── spark-env.sh
│   └── spark-defaults.conf
└── nifi/
    └── conf/
docker ps

# 1️⃣ Supprimer les anciens conteneurs interrompus
docker-compose down

# 2️⃣ Supprimer les anciennes images partielles
docker image prune -a -f

# 3️⃣ Relancer le cluster
docker-compose up -d

docker pull bde2020/hadoop-namenode
