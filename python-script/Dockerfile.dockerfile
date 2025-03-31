# Étape 1 - Builder avec dépendances de compilation
FROM python:3.9-slim AS builder

WORKDIR /app
COPY requirements.txt .

RUN apt-get update && \
    apt-get install -y gcc python3-dev && \
    pip install --user --no-cache-dir -r requirements.txt && \
    apt-get remove -y gcc python3-dev && \
    apt-get autoremove -y

# Étape 2 - Image finale
FROM python:3.9-slim

WORKDIR /app
COPY --from=builder /root/.local /root/.local
COPY kafka_to_hbase.py .

ENV PATH=/root/.local/bin:$PATH \
    PYTHONUNBUFFERED=1

ENTRYPOINT ["python", "-u", "kafka_to_hbase.py"]