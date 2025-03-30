# Étape 1 - Builder l'environnement Python
FROM python:3.9-slim as builder

WORKDIR /app
COPY requirements.txt .

RUN pip install --user --no-cache-dir -r requirements.txt

# Étape 2 - Image finale
FROM python:3.9-slim

WORKDIR /app

# Copie des dépendances depuis le builder
COPY --from=builder /root/.local /root/.local
COPY kafka_to_hbase.py .

# Variables d'environnement avec valeurs par défaut
ENV KAFKA_BROKERS="localhost:9092"
ENV KAFKA_TOPIC="aid-mabrouk"
ENV HBASE_HOST="hbase"

# Ajout des outils réseau pour le debug
RUN apt-get update && apt-get install -y \
    netcat \
    && rm -rf /var/lib/apt/lists/*

# Garantit que les scripts Python sont trouvés
ENV PATH=/root/.local/bin:$PATH

# Health check personnalisé
HEALTHCHECK --interval=30s --timeout=3s \
  CMD netstat -an | grep 9092 > /dev/null || exit 1

CMD ["python", "-u", "kafka_to_hbase.py"]