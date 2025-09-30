# Overview

1. Ingest data	into	a	Kafka	topic	from	a	provided	dataset.	
2. Deploy	a	Flink	SQL	job	in	Ververica	Cloud	to	process	the	data.	
3. Calculate	aggregated	analytics	as	described	below.	


# Environment Setup Step

## Azure VM

Create an empty azure Ubuntu24 VM with public IP through [Azure Portal](https://portal.azure.com/#home)

## Kafka installation

1. login to VM terminal use your ssh user with sudo permission
2. upload `src/kafka/insallKafka.sh` in this repository to `/home/<your ssh user>`
3. `sh installKafka.sh <your vm public IP> <your ssh user>`

## Python setup

login to VM termal use your ssh user with sudo permission and run below commands:
```
sudo apt install python3-venv -y

python3 -m venv myenv

source myenv/bin/activate

pip install kafka-python-ng pandas
```
   


# How to run the producer
1. download [kaggle spotify_history.csv](https://www.kaggle.com/datasets/anandshaw2001/top-spotify-songs-in-countries/data?select=spotify_history.csv)
2. upload `spotify_history.csv` and `src/producer/spotify_prod.py` in this repository to `/home/<your ssh user>/`
3. login to VM terminal use your ssh user with sudo permission
4. create kafka topics
   ```
   ./kafka/kafka_2.12-3.9.1/bin/kafka-topics.sh --create --topic spotify-streaming-events --bootstrap-server localhost:9092 --partitions 4 --replication-factor 1
   ./kafka/kafka_2.12-3.9.1/bin/kafka-topics.sh --describe --bootstrap-server localhost:9092 --topic spotify-streaming-events
   ```
5. run producer to produce
   ```
   source myenv/bin/activate
   python3 spotify_prod.py
   ```
6. if producer stops to produce, verify the topic offsets
   ```
   sshuser@mwljzhuvm:~/kafka/kafka_2.12-3.9.1$ bin/kafka-get-offsets.sh --bootstrap-server localhost:9092 --topic spotify-streaming-events
   spotify-streaming-events:0:37578
   spotify-streaming-events:1:37138
   spotify-streaming-events:2:37472
   spotify-streaming-events:3:37672
   sshuser@mwljzhuvm:~/kafka/kafka_2.12-3.9.1$
   ```

# How to deploy the Flink SQL in Ververica Cloud
