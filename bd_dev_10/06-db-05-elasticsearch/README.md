## Домашнее задание к занятию 5. «Elasticsearch»  

### Задача 1  
В этом задании вы потренируетесь в:  
установке Elasticsearch,  
первоначальном конфигурировании Elasticsearch,  
запуске Elasticsearch в Docker.  
Используя Docker-образ centos:7 как базовый и документацию по установке и запуску Elastcisearch:  
составьте Dockerfile-манифест для Elasticsearch,  
соберите Docker-образ и сделайте push в ваш docker.io-репозиторий,  
запустите контейнер из получившегося образа и выполните запрос пути / c хост-машины.  
Требования к elasticsearch.yml:  
данные path должны сохраняться в /var/lib,  
имя ноды должно быть netology_test.  
В ответе приведите:  
текст Dockerfile-манифеста,  
ссылку на образ в репозитории dockerhub,  
ответ Elasticsearch на запрос пути / в json-виде.  

#### Ответ:  
Dockerfile
```
FROM centos:7
#

RUN yum -y install wget \
#    && yum -y install perl-Digest-SHA \
    && wget -o /dev/null https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz \
    && wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 \
#    && shasum -a 512 -c elasticsearch-7.17.0-linux-x86_64.tar.gz.sha512 \
    && tar -xzf elasticsearch-7.17.0-linux-x86_64.tar.gz

ADD elasticsearch.yml /elasticsearch-7.17.0/config/
ENV JAVA_HOME=/elasticsearch-7.17.0/jdk/
ENV ES_HOME=/elasticsearch-7.17.0

RUN groupadd elasticsearch \
    && useradd -g elasticsearch elasticsearch \
    && mkdir /var/lib/logs \
    && chown elasticsearch:elasticsearch /var/lib/logs \
    && mkdir /var/lib/data \
    && chown elasticsearch:elasticsearch /var/lib/data \
    && chown -R elasticsearch:elasticsearch /elasticsearch-7.17.0 \
    && mkdir /elasticsearch-7.17.0/snapshots \
    && chown elasticsearch:elasticsearch /elasticsearch-7.17.0/snapshots

USER elasticsearch
CMD ["/usr/sbin/init"]
CMD ["/elasticsearch-7.17.0/bin/elasticsearch"]
```
elasticsearch.yml
```
cluster.name: netology_test
discovery.type: single-node
path.data: /var/lib/data
path.logs: /var/lib/logs
path.repo: /elasticsearch-7.17.0/snapshots
network.host: 0.0.0.0
discovery.seed_hosts: ["127.0.0.1", "[::1]"]
```
Образ в репозитории DockerHub


Ответ elasticsearch на запрос пути / в json виде
```
{
  "name" : "44707c71aa4e",
  "cluster_name" : "netology_test",
  "cluster_uuid" : "yNQgsK7wSMKIAgiyOisViQ",
  "version" : {
    "number" : "7.17.0",
    "build_flavor" : "default",
    "build_type" : "tar",
    "build_hash" : "bee86328705acaa9a6daede7140defd4d9ec56bd",
    "build_date" : "2022-01-28T08:36:04.875279988Z",
    "build_snapshot" : false,
    "lucene_version" : "8.11.1",
    "minimum_wire_compatibility_version" : "6.8.0",
    "minimum_index_compatibility_version" : "6.0.0-beta1"
  },
  "tagline" : "You Know, for Search"
}
```

### Задача 2  
В этом задании вы научитесь:  
создавать и удалять индексы,  
изучать состояние кластера,  
обосновывать причину деградации доступности данных.  
Ознакомьтесь с документацией и добавьте в Elasticsearch 3 индекса в соответствии с таблицей:  
Имя	Количество реплик	Количество шард  
ind-1	0	1  
ind-2	1	2  
ind-3	2	4  
Получите список индексов и их статусов, используя API, и приведите в ответе на задание.  
Получите состояние кластера Elasticsearch, используя API.  
Как вы думаете, почему часть индексов и кластер находятся в состоянии yellow?  
Удалите все индексы.  


#### Ответ:  
Создаем индексы  
```
curl -X PUT localhost:9200/ind-1 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0,  "number_of_shards": 1 }}'
curl -X PUT localhost:9200/ind-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 1,  "number_of_shards": 2 }}'
curl -X PUT localhost:9200/ind-3 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 2,  "number_of_shards": 4 }}'
```
Получаем список индексов
```
sh-4.2$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   ind-1            kZwWcmBDQ2aX4ImIiIjthA   1   0          0            0       226b           226b
yellow open   ind-3            NQZ-QJxkToWzTZ2WmwavvQ   4   2          0            0       904b           904b
yellow open   ind-2            o-iqHu8wQvKymDbPknIn9w   2   1          0            0       452b           452b
sh-4.2$
```
Получаем статус индексов
```
sh-4.2$ curl -X GET 'http://localhost:9200/_cluster/health/ind-1?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "green",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 1,
  "active_shards" : 1,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 0,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 100.0
}
sh-4.2$ curl -X GET 'http://localhost:9200/_cluster/health/ind-2?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 2,
  "active_shards" : 2,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 2,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
sh-4.2$ curl -X GET 'http://localhost:9200/_cluster/health/ind-3?pretty'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 4,
  "active_shards" : 4,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 8,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
sh-4.2$
```
Получаем состояние кластера
```
sh-4.2$ curl -XGET 'localhost:9200/_cluster/health/?pretty=true'
{
  "cluster_name" : "netology_test",
  "status" : "yellow",
  "timed_out" : false,
  "number_of_nodes" : 1,
  "number_of_data_nodes" : 1,
  "active_primary_shards" : 10,
  "active_shards" : 10,
  "relocating_shards" : 0,
  "initializing_shards" : 0,
  "unassigned_shards" : 10,
  "delayed_unassigned_shards" : 0,
  "number_of_pending_tasks" : 0,
  "number_of_in_flight_fetch" : 0,
  "task_max_waiting_in_queue_millis" : 0,
  "active_shards_percent_as_number" : 50.0
}
sh-4.2$
```
Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?  

Эти индексы имеют реплики, а так как других серверов нет, то реплики отсутствуют. Состояние кластера указывает что часть secondary шард unassigned.  

Удаляем все индексы  
```
sh-4.2$ curl -X DELETE 'http://localhost:9200/ind-1?pretty'
{
  "acknowledged" : true
}
sh-4.2$ curl -X DELETE 'http://localhost:9200/ind-2?pretty'
{
  "acknowledged" : true
}
sh-4.2$ curl -X DELETE 'http://localhost:9200/ind-3?pretty'
{
  "acknowledged" : true
}
sh-4.2$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index            uuid                   pri rep docs.count docs.deleted store.size pri.store.size
sh-4.2$ 
```


### Задача 3  
В этом задании вы научитесь:  
создавать бэкапы данных,  
восстанавливать индексы из бэкапов.  
Создайте директорию {путь до корневой директории с Elasticsearch в образе}/snapshots.  
Используя API, зарегистрируйте эту директорию как snapshot repository c именем netology_backup.  
Приведите в ответе запрос API и результат вызова API для создания репозитория.  
Создайте индекс test с 0 реплик и 1 шардом и приведите в ответе список индексов.  
Создайте snapshot состояния кластера Elasticsearch.  
Приведите в ответе список файлов в директории со snapshot.  
Удалите индекс test и создайте индекс test-2. Приведите в ответе список индексов.  
Восстановите состояние кластера Elasticsearch из snapshot, созданного ранее.  
Приведите в ответе запрос к API восстановления и итоговый список индексов.  

#### Ответ:  
Регистрируем директорию netology_backup
```
sh-4.2$ curl -X POST localhost:9200/_snapshot/netology_backup?pretty -H 'Content-Type: application/json' -d'{"type": "fs", "settings": { "location":"/elasticsearch-7.17.0/snapshots" }}'
{
  "acknowledged" : true
}
sh-4.2$
```
Создаем индекс test с 0 реплик и 1 шардом.
```
curl -X PUT localhost:9200/test -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'
```
```
sh-4.2$  curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test  QtwnianWTh25QgobZtPGng   1   0          0            0       226b           226b
```
Создаем snapshot.
```
sh-4.2$ curl -X PUT localhost:9200/_snapshot/netology_backup/elasticsearch?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","uuid":"P57ew79TS3ObZ_8qk8iMIQ","repository":"netology_backup","version_id":7170099,"version":"7.17.0","indices":["test",".ds-.logs-deprecation.elasticsearch-default-2022.02.28-000001",".ds-ilm-history-5-2022.02.28-000001"],"data_streams":["ilm-history-5",".logs-deprecation.elasticsearch-default"],"include_global_state":true,"state":"SUCCESS","start_time":"2022-02-28T11:09:28.190Z","start_time_in_millis":1646046568190,"end_time":"2022-02-28T11:09:28.595Z","end_time_in_millis":1646046568595,"duration_in_millis":405,"failures":[],"shards":{"total":3,"failed":0,"successful":3},"feature_states":[]}}
```
```
sh-4.2$ ls -la /elasticsearch-7.17.0/snapshots/
total 60
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Feb 28 11:09 .
drwxr-xr-x 1 elasticsearch elasticsearch  4096 Feb 28 10:57 ..
-rw-r--r-- 1 elasticsearch elasticsearch  1168 Feb 28 11:09 index-0
-rw-r--r-- 1 elasticsearch elasticsearch     8 Feb 28 11:09 index.latest
drwxr-xr-x 5 elasticsearch elasticsearch  4096 Feb 28 11:09 indices
-rw-r--r-- 1 elasticsearch elasticsearch 28816 Feb 28 11:09 meta-P57ew79TS3ObZ_8qk8iMIQ.dat
-rw-r--r-- 1 elasticsearch elasticsearch   625 Feb 28 11:09 snap-P57ew79TS3ObZ_8qk8iMIQ.dat
sh-4.2$
```
Удаляем индекс test и создаем индекс test-2.
```
sh-4.2$ curl -X DELETE 'http://localhost:9200/test?pretty'
{
  "acknowledged" : true
}
sh-4.2$ curl -X PUT localhost:9200/test-2 -H 'Content-Type: application/json' -d'{ "settings": { "number_of_replicas": 0, "number_of_shards": 1 }}'
{"acknowledged":true,"shards_acknowledged":true,"index":"test-2"} 
sh-4.2$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 7pVzzsWXQoiIP_YI1x8kag   1   0          0            0       226b           226b
sh-4.2$
```
Восстановление состояние кластера elasticsearch из snapshot, созданного ранее."
```
curl -X POST "localhost:9200/.*/_close?pretty"
{
  "acknowledged" : true,
  "shards_acknowledged" : true,
  "indices" : {
    ".ds-ilm-history-5-2022.02.28-000001" : {
      "closed" : true
    },
    ".ds-.logs-deprecation.elasticsearch-default-2022.02.28-000001" : {
      "closed" : true
    }
  }
}
sh-4.2$ curl -X POST localhost:9200/_snapshot/netology_backup/elasticsearch/_restore?wait_for_completion=true
{"snapshot":{"snapshot":"elasticsearch","indices":["test",".ds-ilm-history-5-2022.02.28-000001",".ds-.logs-deprecation.elasticsearch-default-2022.02.28-000001"],"shards":{"total":3,"failed":0,"successful":3}}}sh-4.2$
```
Итоговый список индексов.
```
sh-4.2$ curl -X GET 'http://localhost:9200/_cat/indices?v'
health status index  uuid                   pri rep docs.count docs.deleted store.size pri.store.size
green  open   test-2 7pVzzsWXQoiIP_YI1x8kag   1   0          0            0       226b           226b
green  open   test   G_0ihRykQQ6micKT2MKYoA   1   0          0            0       226b           226b
sh-4.2$ 
```
