## Домашнее задание к занятию 3. «Введение. Экосистема. Архитектура. Жизненный цикл Docker-контейнера»  

### Задача 1  
Сценарий выполнения задачи:  

создайте свой репозиторий на https://hub.docker.com;  
выберите любой образ, который содержит веб-сервер Nginx;  
создайте свой fork образа;  
реализуйте функциональность: запуск веб-сервера в фоне с индекс-страницей, содержащей HTML-код ниже:  
```
<html>
<head>
Hey, Netology
</head>
<body>
<h1>I’m DevOps Engineer!</h1>
</body>
</html>
```
Опубликуйте созданный fork в своём репозитории и предоставьте ответ в виде ссылки на https://hub.docker.com/username_repo.

#### Ответ:  
Создаем Dockerfile  
```
FROM nginx:latest
COPY ./index.html /usr/share/nginx/html/index.html
```
Запускаем сборку образа
```
vagrant@ubuntu-20:~/docker$ docker build -t networkdockering/panarin.netology .
Sending build context to Docker daemon  3.072kB
Step 1/2 : FROM nginx:latest
latest: Pulling from library/nginx
1fe172e4850f: Pull complete
35c195f487df: Pull complete
213b9b16f495: Pull complete
a8172d9e19b9: Pull complete
f5eee2cb2150: Pull complete
93e404ba8667: Pull complete
Digest: sha256:6d701d83f2a1bb99efb7e6a60a1e4ba6c495bc5106c91709b0560d13a9bf8fb6
Status: Downloaded newer image for nginx:latest
 ---> fa5269854a5e
Step 2/2 : COPY ./index.html /usr/share/nginx/html/index.html
 ---> 36447e0733b1
Successfully built 36447e0733b1
Successfully tagged networkdockering/panarin.netology:latest
```
```
vagrant@ubuntu-20:~/docker$ docker run -it -d -p 8080:80 --name nginx networkdockering/panarin.netology
5497b32ee8cf86a6ec4f36ad2ce1b5f8ed77ada567973f0aa1eaad0dd25a4415
vagrant@ubuntu-20:~/docker$ docker ps
CONTAINER ID   IMAGE             COMMAND                  CREATED          STATUS          PORTS                                   NAMES
5497b32ee8cf   networkdockering/panarin.netology   "/docker-entrypoint.…"   15 seconds ago   Up 13 seconds   0.0.0.0:8080->80/tcp, :::8080->80/tcp   nginx
vagrant@ubuntu-20:~/docker$ docker images
REPOSITORY        TAG       IMAGE ID       CREATED              SIZE
networkdockering/panarin.netology   latest    36447e0733b1   About a minute ago   142MB
nginx             latest    fa5269854a5e   25 hours ago         142MB
```


### Задача 2
Посмотрите на сценарий ниже и ответьте на вопрос: «Подходит ли в этом сценарии использование Docker-контейнеров или лучше подойдёт виртуальная машина, физическая машина? Может быть, возможны разные варианты?»
Детально опишите и обоснуйте свой выбор.

--

Сценарий:

высоконагруженное монолитное Java веб-приложение;
Nodejs веб-приложение;
мобильное приложение c версиями для Android и iOS;
шина данных на базе Apache Kafka;
Elasticsearch-кластер для реализации логирования продуктивного веб-приложения — три ноды elasticsearch, два logstash и две ноды kibana;
мониторинг-стек на базе Prometheus и Grafana;
MongoDB как основное хранилище данных для Java-приложения;
Gitlab-сервер для реализации CI/CD-процессов и приватный (закрытый) Docker Registry.

#### Ответ:  


### Задача 3
Запустите первый контейнер из образа centos c любым тегом в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.
Запустите второй контейнер из образа debian в фоновом режиме, подключив папку /data из текущей рабочей директории на хостовой машине в /data контейнера.
Подключитесь к первому контейнеру с помощью docker exec и создайте текстовый файл любого содержания в /data.
Добавьте ещё один файл в папку /data на хостовой машине.
Подключитесь во второй контейнер и отобразите листинг и содержание файлов в /data контейнера.

#### Ответ:  


### Задача 4 (*)
Воспроизведите практическую часть лекции самостоятельно.
Соберите Docker-образ с Ansible, загрузите на Docker Hub и пришлите ссылку вместе с остальными ответами к задачам.

#### Ответ:  

