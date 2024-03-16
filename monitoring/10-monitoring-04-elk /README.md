# Домашнее задание к занятию 15 «Система сбора логов Elastic Stack»  

## Задание 1

Вам необходимо поднять в докере и связать между собой:

- elasticsearch (hot и warm ноды);
- logstash;
- kibana;
- filebeat.

Logstash следует сконфигурировать для приёма по tcp json-сообщений.

Filebeat следует сконфигурировать для отправки логов docker вашей системы в logstash.

В директории [help](./help) находится манифест docker-compose и конфигурации filebeat/logstash для быстрого 
выполнения этого задания.

Результатом выполнения задания должны быть:

- скриншот `docker ps` через 5 минут после старта всех контейнеров (их должно быть 5);
- скриншот интерфейса kibana;
- docker-compose манифест (если вы не использовали директорию help);
- ваши yml-конфигурации для стека (если вы не использовали директорию help).

### Ответ:  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/monitoring/10-monitoring-04-elk%20/img/1.png)  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/monitoring/10-monitoring-04-elk%20/img/2.png)  


## Задание 2

Перейдите в меню [создания index-patterns  в kibana](http://localhost:5601/app/management/kibana/indexPatterns/create) и создайте несколько index-patterns из имеющихся.

Перейдите в меню просмотра логов в kibana (Discover) и самостоятельно изучите как отображаются логи и как производить поиск по логам.

### Ответ:  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/monitoring/10-monitoring-04-elk%20/img/3.png)  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/monitoring/10-monitoring-04-elk%20/img/4.png)  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/monitoring/10-monitoring-04-elk%20/img/5.png)  
