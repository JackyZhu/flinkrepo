# Overview

1. Ingest data	into	a	Kafka	topic	from	a	provided	dataset.	
2. Deploy	a	Flink	SQL	job	in	Ververica	Cloud	to	process	the	data.	
3. Calculate	aggregated	analytics	as	described	below.	


# Environment Setup Step

## Azure VM

Create an empty azure Ubuntu24 VM with public IP through [Azure Portal](https://portal.azure.com/#home)

## Kafka installation

1. login to VM terminal use your ssh user with sudo permission
2. upload `src/kafka/insallKafka.sh` to `/home/<your ssh user>`
3. `sh installKafka.sh <your vm public IP> <your ssh user>`

## Python setup



# How to run the producer



# How to deploy the Flink SQL in Ververica Cloud
