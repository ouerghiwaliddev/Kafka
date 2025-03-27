#!/bin/bash

# Chemin vers le dossier Kafka (modifie-le selon ton installation)
KAFKA_HOME="$HOME/kafka_2.13-3.1.0"

# Vérifier si Zookeeper est déjà en cours d'exécution
if pgrep -f "zookeeper" > /dev/null
then
    echo "✅ Zookeeper est déjà en cours d'exécution."
else
    echo "🚀 Démarrage de Zookeeper..."
    nohup $KAFKA_HOME/bin/zookeeper-server-start.sh $KAFKA_HOME/config/zookeeper.properties > zookeeper.log 2>&1 &
    sleep 5  # Attendre quelques secondes
fi

# Vérifier si Kafka est déjà en cours d'exécution
if pgrep -f "kafka.Kafka" > /dev/null
then
    echo "✅ Kafka est déjà en cours d'exécution."
else
    echo "🚀 Démarrage de Kafka..."
    nohup $KAFKA_HOME/bin/kafka-server-start.sh $KAFKA_HOME/config/server.properties > kafka.log 2>&1 &
    sleep 5
fi

# Demander à l'utilisateur le nom du topic
read -p "Entrez le nom du topic à créer : " TOPIC_NAME

# Créer le topic dans Kafka
$KAFKA_HOME/bin/kafka-topics.sh --create --topic "$TOPIC_NAME" --bootstrap-server localhost:9092 --partitions 1 --replication-factor 1

echo "🎯 Le topic '$TOPIC_NAME' a été créé avec succès !"

# Démarrer un consumer Kafka avec l'heure de réception
echo "🎧 Démarrage du consumer pour le topic '$TOPIC_NAME'..."
nohup $KAFKA_HOME/bin/kafka-console-consumer.sh --bootstrap-server localhost:9092 --topic "$TOPIC_NAME" --from-beginning | while read line; do echo "$(date '+[%Y-%m-%d %H:%M:%S]') $line"; done > consumer.log 2>&1 &
echo "📥 Consumer en cours d'écoute..."
echo "Ecire la commade de producer: bin/kafka-console-producer.sh --broker-list walid-HP-Laptop:9092 --topic $TOPIC_NAME"
