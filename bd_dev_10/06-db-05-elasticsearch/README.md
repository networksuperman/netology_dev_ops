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
Важно  
При проектировании кластера Elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря данных индексов, вплоть до полной, при деградации системы.  

#### Ответ:  


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

