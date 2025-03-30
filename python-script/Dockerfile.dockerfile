FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY kafka_to_hbase.py .

ENTRYPOINT ["python", "-u", "kafka_to_hbase.py"]
CMD ["--topic", "aid-mabrouk"]  # Valeur par défaut