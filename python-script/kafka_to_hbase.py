import argparse
import happybase
from kafka import KafkaConsumer

parser = argparse.ArgumentParser()
parser.add_argument('--topic', required=True, help='Nom du topic Kafka')
parser.add_argument('--hbase-host', default='hbase', help='HBase hostname')
parser.add_argument('--kafka-brokers', default='kafka:9092', help='Kafka brokers')
args = parser.parse_args()

# Connexion HBase
connection = happybase.Connection(args.hbase_host)
table = connection.table('kafka_messages')

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