#!/bin/bash

# Команда создаст известного пользователя с известным паролем
curl -X POST -u elastic:$ELASTIC_PASSWORD "elastic:9200/_security/user/${ELASTIC_USERNAME}?pretty" -H 'Content-Type: application/json' -d'
{
  "password" : "'${ELASTIC_PASSWORD}'",
  "roles" : [ "superuser" ],
  "full_name" : "Netology 11.3",
  "enabled" : true
}
'
# Команда рандомит пароль стандартного админа
RAND_PASSWORD=$(echo $RANDOM | md5sum | head -c 20; echo;)
curl -X PUT --silent --output $(mktemp) -u ${ELASTIC_USERNAME}:$ELASTIC_PASSWORD "elastic:9200/_security/user/elastic/_password?pretty" -H 'Content-Type: application/json' -d'
{
  "password" : "'${RAND_PASSWORD}'"
}
'
