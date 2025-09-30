# Overview

1. Ingest data	into	a	Kafka	topic	from	a	provided	dataset.	
2. Deploy a	Flink	SQL job in Ververica	Cloud	to	process the	data.	
3. Calculate aggregated	analytics as described below.
   1.	Calculate the play count per track name and show on the UI the	tracks which has more than	120plays.	
   2.	Analyze daily engagement of the most played track from the first query:
      -	Daily	play counts.
      -	Daily	total	play duration in minutes.
      -	Results should	allow	identifying	how interest changes	daily	over time for that track.


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
1. login [ververica cloud](https://app.ververica.cloud/dashboard)
2. [new workspace](https://app.ververica.cloud/create-workspace) until you see the workspace is in running status
   <img width="1031" height="177" alt="image" src="https://github.com/user-attachments/assets/1ed93c49-ae87-4c8a-8d23-e34714a863b4" />
3. click your running workspace
4. go to **Session Clusters** page and click **Create Session Cluster**
5. check your cluster status until you see it's in running status
   <img width="1713" height="314" alt="image" src="https://github.com/user-attachments/assets/7b309219-21ba-45da-bd28-84d019658ddc" />
6. go to **SQL Editor** page and click **New from file** to import your script file
   <img width="852" height="359" alt="image" src="https://github.com/user-attachments/assets/c95d8a9b-b044-4485-9bdc-f19b82e526cb" />
8. click **validate** button to verfiy your sql script
9. click **Debug Selection** to deploy your sql
   <img width="803" height="244" alt="image" src="https://github.com/user-attachments/assets/9f34efeb-296d-4920-9c66-63c112ed42b4" />
   <img width="784" height="290" alt="image" src="https://github.com/user-attachments/assets/3f6302e6-877a-44c6-80fd-2039d9527bde" />
10. check in **result** tab
   <img width="913" height="705" alt="image" src="https://github.com/user-attachments/assets/cde0ea21-a22d-4b38-bbf2-f941c1888389" />

# Deploy popular_tracks Flink SQL
1. go to **SQL Editor** page and click **New from file** to import `src/flinksql/popular_tracks.sql`
2. replace **properties.bootstrap.servers** with your vm public IP in the sql
3. verify your result in SQL Editor UI:
   <img width="2043" height="1161" alt="image" src="https://github.com/user-attachments/assets/84070278-021c-45ce-bd5f-d18c3a2ce00e" />


# Deploy most_played_track_daily_engagement Flink SQL

1. After analyzing the result of `src/flinksql/popular_tracks.sql`, we get **Ode To The Mets** as the most played track
2. go to **SQL Editor** page and click **New from file** to import `src/flinksql/most_played_track_daily_engagement.sql`
3. replace **properties.bootstrap.servers** with your vm public IP in the sql
4. verify your result in SQL Editor UI:
   <img width="2544" height="1314" alt="image" src="https://github.com/user-attachments/assets/38aa89b0-2fb8-487e-99b7-e68b3a3e8ad7" />
5. alternatively, verify your result in `resources/most_played_track_daily_engagement.csv`



