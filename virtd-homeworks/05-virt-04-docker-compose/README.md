## Домашнее задание к занятию 4. «Оркестрация группой Docker-контейнеров на примере Docker Compose»  

### Задача 1  
Создайте собственный образ любой операционной системы (например, debian-11) с помощью Packer версии 1.7.0 . Перед выполнением задания изучите (инструкцию!!!). В инструкции указана минимальная версия 1.5, но нужно использовать 1.7, так как там есть нужный нам функционал  
Чтобы получить зачёт, вам нужно предоставить скриншот страницы с созданным образом из личного кабинета YandexCloud.  

#### Ответ: 
![](https://github.com/networksuperman/netology_dev_ops/blob/main/virtd-homeworks/05-virt-04-docker-compose/img/1.1.png)  


### Задача 2  
2.1. Создайте вашу первую виртуальную машину в YandexCloud с помощью web-интерфейса YandexCloud.  

#### Ответ: 
![](https://github.com/networksuperman/netology_dev_ops/blob/main/virtd-homeworks/05-virt-04-docker-compose/img/2.1.png)  


### Задача 3  
С помощью Ansible и Docker Compose разверните на виртуальной машине из предыдущего задания систему мониторинга на основе Prometheus/Grafana. Используйте Ansible-код в директории (src/ansible).  
Чтобы получить зачёт, вам нужно предоставить вывод команды "docker ps" , все контейнеры, описанные в docker-compose, должны быть в статусе "Up".  

#### Ответ: 
![](https://github.com/networksuperman/netology_dev_ops/blob/main/virtd-homeworks/05-virt-04-docker-compose/img/3.1.png)  


### Задача 4  
Откройте веб-браузер, зайдите на страницу http://<внешний_ip_адрес_вашей_ВМ>:3000.  
Используйте для авторизации логин и пароль из .env-file.  
Изучите доступный интерфейс, найдите в интерфейсе автоматически созданные docker-compose-панели с графиками(dashboards).  
Подождите 5-10 минут, чтобы система мониторинга успела накопить данные.  
Чтобы получить зачёт, предоставьте:  
скриншот работающего веб-интерфейса Grafana с текущими метриками, как на примере ниже.  

#### Ответ: 
![](https://github.com/networksuperman/netology_dev_ops/blob/main/virtd-homeworks/05-virt-04-docker-compose/img/4.1.png)  


