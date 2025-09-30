import pandas as pd
import json
from kafka import KafkaProducer

# Kafka configuration
KAFKA_BROKER = 'localhost:9092'  # Change if your Kafka broker is remote
TOPIC_NAME = 'spotify-streaming-events'

# Initialize Kafka producer
producer = KafkaProducer(
    bootstrap_servers=KAFKA_BROKER,
    value_serializer=lambda v: json.dumps(v).encode('utf-8')
)

# Load the dataset
csv_path = 'spotify_history.csv'  # Update path if needed
df = pd.read_csv(csv_path)

# Optional: fill NaNs and convert timestamps if needed
df.fillna('', inplace=True)

# Produce each row as a JSON message
for index, row in df.iterrows():
    message = row.to_dict()
    producer.send(TOPIC_NAME, value=message)
    print(f"Sent message {index + 1}: {message}")

producer.flush()
producer.close()
print("All messages sent.")

