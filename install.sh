#!/bin/bash
# install.sh

docker pull monica
docker pull mysql

docker volume create monica-monica-data
docker volume create monica-mysql-data

export APP_KEY="$(head -c 32 /dev/random | base64 | head -c 32)"
export HASH_SALT="$(head -c 54 /dev/random | base64 | head -c 52)"
export DB_PASSWORD="$(head -c 32 /dev/random | base64 | head -c 32)"
read -p 'LocationIQ API Key: ' LOCATION_IQ_API_KEY
export LOCATION_IQ_API_KEY
read -p 'Mailjet API Key: ' MAILJET_API_KEY
export MAILJET_API_KEY
read -p 'Mailjet Secret Key: ' MAILJET_SECRET_KEY
export MAILJET_SECRET_KEY
envsubst '$APP_KEY,$HASH_SALT,$DB_PASSWORD,$LOCATION_IQ_API_KEY,$MAILJET_API_KEY,$MAILJET_SECRET_KEY' < .env.template > .env

docker run -d --network=none -e MYSQL_RANDOM_ROOT_PASSWORD=true -e MYSQL_DATABASE=monica -e MYSQL_USER=monica -e MYSQL_PASSWORD=${DB_PASSWORD} -v monica-mysql-data:/var/lib/mysql --name mysql --rm mysql
sleep 10
docker container stop mysql
