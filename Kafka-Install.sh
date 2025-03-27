#!/bin/bash

# Variables
download_url="https://downloads.apache.org/kafka/3.5.1/kafka_2.13-3.5.1.tgz"
kafka_dir="/opt/kafka"

# Vérifier si Java est installé
if ! command -v java &> /dev/null
then
    echo "Java n'est pas installé. Installation en cours..."
    sudo apt update
    sudo apt install -y default-jdk
fi

# Télécharger et extraire Kafka
if [ ! -d "$kafka_dir" ]; then
    echo "Téléchargement de Kafka..."
    wget "$download_url" -O /tmp/kafka.tgz
    echo "Extraction de Kafka..."
    sudo mkdir -p "$kafka_dir"
    sudo tar -xzf /tmp/kafka.tgz --strip-components=1 -C "$kafka_dir"
    rm /tmp/kafka.tgz
fi

# Démarrer ZooKeeper
if pgrep -f "zookeeper" > /dev/null
then
    echo "ZooKeeper est déjà en cours d'exécution."
else
    echo "Démarrage de ZooKeeper..."
    nohup "$kafka_dir/bin/zookeeper-server-start.sh" "$kafka_dir/config/zookeeper.properties" > /tmp/zookeeper.log 2>&1 &
    sleep 5
fi

# Démarrer Kafka
if pgrep -f "kafka" > /dev/null
then
    echo "Kafka est déjà en cours d'exécution."
else
    echo "Démarrage de Kafka..."
    nohup "$kafka_dir/bin/kafka-server-start.sh" "$kafka_dir/config/server.properties" > /tmp/kafka.log 2>&1 &
fi

echo "Kafka et ZooKeeper ont été installés et démarrés."
