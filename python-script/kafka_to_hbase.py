import argparse
import happybase
from kafka import KafkaConsumer


parser = argparse.ArgumentParser()
parser.add_argument('--topic', required=True)
parser.add_argument('--hbase-host', default='localhost')  # Changé depuis 'hbase'
parser.add_argument('--hbase-port', type=int, default=9090)  # Nouveau paramètre
args = parser.parse_args()

# Configuration de la connexion
connection = happybase.Connection(
    host=args.hbase_host,
    port=args.hbase_port,  # Port standard HBase: 9090 (Thrift)
    timeout=30000  # Timeout augmenté
)
# Consumer Kafka
consumer = KafkaConsumer(
    args.topic,
    bootstrap_servers=args.kafka_brokers,
    auto_offset_reset='earliest'
)

print(f"🚀 Démarrage du consumer pour le topic {args.topic}...")
for message in consumer:
    try:
        table.put(
            str(message.timestamp).encode('utf-8'),
            {'cf:message': message.value.encode('utf-8')}
        )
        print(f"✓ Message stocké (offset: {message.offset})")
    except Exception as e:
        print(f"✗ Erreur: {str(e)}")


