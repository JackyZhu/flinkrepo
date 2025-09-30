#!/bin/bash

brokerIP=$1
if [ -z "$brokerIP" ]
then
      echo "Broker public IP is required"
      exit 1
fi

user=$2
if [ -z "$user" ]
then
      echo "ssh user name is required"
      exit 1
fi

cd ~

sudo apt update
sudo apt search openjdk
sudo apt install openjdk-11-jdk -y


mkdir kafka

cd kafka

wget https://dlcdn.apache.org/kafka/3.9.1/kafka_2.12-3.9.1.tgz

tar -xvzf kafka_2.12-3.9.1.tgz

cd kafka_2.12-3.9.1/

sed -i '/^#advertised.listeners=/c\advertised.listeners=PLAINTEXT://'"$broker"':9092'



zkService="
[Unit]
Description=Apache Zookeeper Server
After=network.target

[Service]
Type=simple
User=sshuser
ExecStart=/home/sshuser/kafka/kafka_2.12-3.9.1/bin/zookeeper-server-start.sh /home/sshuser/kafka/kafka_2.12-3.9.1/config/zookeeper.properties
ExecStop=/home/sshuser/kafka/kafka_2.12-3.9.1/bin/zookeeper-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
"

kafkaService="
[Unit]
Description=Apache Kafka Server
After=zookeeper.service

[Service]
Type=simple
User=sshuser
ExecStart=/home/sshuser/kafka/kafka_2.12-3.9.1/bin/kafka-server-start.sh /home/sshuser/kafka/kafka_2.12-3.9.1/config/server.properties
ExecStop=/home/sshuser/kafka/kafka_2.12-3.9.1/bin/kafka-server-stop.sh
Restart=on-abnormal

[Install]
WantedBy=multi-user.target
"

zkService=`echo "$zkService" | sed -e 's/sshuser/'"$user"'/g'`
kafkaService=`echo "$kafkaService" | sed -e 's/sshuser/'"$user"'/g'`


sudo echo "$zkService" > /etc/systemd/system/zookeeper.service
sudo echo "$kafkaService" > /etc/systemd/system/kafka.service

sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable zookeeper
sudo systemctl enable kafka
sudo systemctl start zookeeper
sudo systemctl start kafka

sudo systemctl status kafka


