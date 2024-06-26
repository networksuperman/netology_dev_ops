
# Домашнее задание к занятию "11.02 Микросервисы: принципы"

Вы работаете в крупной компанию, которая строит систему на основе микросервисной архитектуры.
Вам как DevOps специалисту необходимо выдвинуть предложение по организации инфраструктуры, для разработки и эксплуатации.

## Задача 1: API Gateway 

> Предложите решение для обеспечения реализации API Gateway. Составьте сравнительную таблицу возможностей различных программных решений. На основе таблицы сделайте выбор решения.
> 
> Решение должно соответствовать следующим требованиям:
> - Маршрутизация запросов к нужному сервису на основе конфигурации
> - Возможность проверки аутентификационной информации в запросах
> - Обеспечение терминации HTTPS
> 
> Обоснуйте свой выбор.


| Решение | Маршрутизация | Аутентификация | Терминация HTTPS | Бесплатно/Открыто? |
|---|---|---|---|---|
| Kong | + | + | + | Открыто, Apache 2.0 |
| Tyk.io | + | + | + | Открыто, MPL |
| Apache APISIX | + | + | + | Открыто, Apache 2.0 |
| APIGee | + | + | + | Платно |
| Amazon AWS API Gateway | + | + | - | Платно |
| Azure API Gateway | + | + | + | Платно |
| NGINX Plus | + | + | + | Платно |
| KrakenD | + | + | + | Двойное лицензирование, нужные нам функции частично в платной версии |

По фукнционалу нам подходят все, кроме разве что Amazon AWS API Gateway, т.к. он by design не умеет делать терминацию HTTPS, вернее он требует от бекенда использовать самоподписной SSL-сертификат.

Наиболее оптимальным будет на первых порах использовать Kong, т.к. это наиболее популярное бесплатное решение, в основе которого используется не менее популярный и хорошо знакомый многим инженерам NGINX.

Конечно, если не используется облачная инфраструктура. Тогда я бы предложил использовать решение, родное для платформы, даже если это AWS.

## Задача 2: Брокер сообщений

> Составьте таблицу возможностей различных брокеров сообщений. На основе таблицы сделайте обоснованный выбор решения.
> 
> Решение должно соответствовать следующим требованиям:
> - Поддержка кластеризации для обеспечения надежности
> - Хранение сообщений на диске в процессе доставки
> - Высокая скорость работы
> - Поддержка различных форматов сообщений
> - Разделение прав доступа к различным потокам сообщений
> - Простота эксплуатации
> 
> Обоснуйте свой выбор.

| Параметр | RabbitMQ | Apache Kafka | ActiveMQ | NATS | Redis |
|:---|:---:|:---:|:---:|:---:|:---:|
| Поддержка кластеризации для обеспечения надежности | + | + | + | + | + |
| Хранение сообщений на диске в процессе доставки | + | + | + | + | + |
| Высокая скорость работы | +- | + | - | + | + |
| Поддержка различных форматов сообщений | AMQP, MQTT, STOMP | Только binary через TCP Socket | 10 форматов, включая AMQP, AUTO, MQTT, REST | Только NATS Streaming Protocol | Только RESP |
| Разделение прав доступа к различным потокам сообщений | + | + | + | + | + |
| Простота эксплуатации | + | - | + | + | + |

Из постановки задачи в начале не очень понятен характер нагрузки. Например:
- Понятно, что компания большая, но коррелирует ли это с объёмом сообщений, которые будут литься на брокера? Хватит ли RabbitMQ, потому что он популярный и его просто настроить, или лучше озадачиться чем-то помощней, вроде Apache Kafka? 
- Действительно важна "всеядность" или это требование включили "про запас" с заделом на будущее?
- Очередь сообщений нужна только для связи микросервисов, или планируется подключать какие-то внешние системы и монолитные легаси системы?

Как универсальное решение, я бы вероятно взял RabbitMQ - он усреднённый по всем параметрам, очень распространён, и проще найти специалистов, которые с ним работали.

Если брокер нужен только для связи между микросервисами, тогда наверное NATS - он написан специально для этого.
## Задача 3: API Gateway * (необязательная)

<details><summary>Описание</summary>

> ### Есть три сервиса:
> 
> **minio**
> - Хранит загруженные файлы в бакете images
> - S3 протокол
> 
> **uploader**
> - Принимает файл, если он картинка сжимает и загружает его в minio
> - POST /v1/upload
> 
> **security**
> - Регистрация пользователя POST /v1/user
> - Получение информации о пользователе GET /v1/user
> - Логин пользователя POST /v1/token
> - Проверка токена GET /v1/token/validation
> 
> ### Необходимо воспользоваться любым балансировщиком и сделать API Gateway:
> 
> **POST /v1/register**
> - Анонимный доступ.
> - Запрос направляется в сервис security POST /v1/user
> 
> **POST /v1/token**
> - Анонимный доступ.
> - Запрос направляется в сервис security POST /v1/token
> 
> **GET /v1/user**
> - Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
> - Запрос направляется в сервис security GET /v1/user
> 
> **POST /v1/upload**
> - Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
> - Запрос направляется в сервис uploader POST /v1/upload
> 
> **GET /v1/user/{image}**
> - Проверка токена. Токен ожидается в заголовке Authorization. Токен проверяется через вызов сервиса security GET /v1/token/validation/
> - Запрос направляется в сервис minio  GET /images/{image}
>

</details>

### Ожидаемый результат

> Результатом выполнения задачи должен быть docker compose файл запустив который можно локально выполнить следующие команды с успешным результатом.
> Предполагается что для реализации API Gateway будет написан конфиг для NGinx или другого балансировщика нагрузки который будет запущен как сервис через docker-compose и будет обеспечивать балансировку и проверкbashу аутентификации входящих запросов авторизаци
> ```
> curl -X POST -H 'Content-Type: application/json' -d '{"login":"bob", "password":"qwe123"}' http://localhost/token
> ```
> 
> **Загрузка файла**
> 
> ```bash
> curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJib2IifQ.hiMVLmssoTsy1MqbmIoviDeFPvo-nCd92d4UFiN2O2I' -H 'Content-Type: octet/stream' --data-binary @yourfilename.jpg http://localhost/upload
> ```
> 
> **Получение файла**
> 
> ```bash
> curl -X GET http://localhost/images/4e6df220-295e-4231-82bc-45e4b1484430.jpg
> ```

Конфиг гейтвея [nginx.conf](https://github.com/networksuperman/netology_dev_ops/blob/main/micros-homeworks/11-microservices-02-principles/gateway/nginx.conf)

Проверка работы:

1. Регистрация
    ```bash
    curl -X POST -H 'Content-Type: application/json' -d '{"login":"new_user", "password":"secretpassword"}' http://localhost/register
    {"Success":"User new_user registered"}
    ```
1. Получение токена
    ```bash
    curl -X POST -H 'Content-Type: application/json' -d '{"login":"new_user", "password":"secretpassword"}' http://localhost/token
    eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJuZXdfdXNlciJ9.B5g59k4TY_oXJ7e0AcZ2Fz_N6cZz-dKRzWKTW1-f8t8
    ```
1. Попытка загрузить картинку без токена
    ```bash
    curl -X POST -H 'Content-Type: octet/stream' --data-binary @1.jpg http://localhost/upload
    <html>
    <head><title>401 Authorization Required</title></head>
    <body>
    <center><h1>401 Authorization Required</h1></center>
    <hr><center>nginx/1.21.6</center>
    </body>
    </html>
    ```
1. Загрузка картинки с токеном
    ```bash
    curl -X POST -H 'Authorization: Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJuZXdfdXNlciJ9.B5g59k4TY_oXJ7e0AcZ2Fz_N6cZz-dKRzWKTW1-f8t8' -H 'Content-Type: octet/stream' --data-binary @1.jpg http://localhost/upload
    {"filename":"8f5d79ba-931c-4b42-bc69-59c2fa510181.jpg"}
    ```
1. Скачивание картинки
    ```bash
    curl -X GET http://localhost/images/8f5d79ba-931c-4b42-bc69-59c2fa510181.jpg > 2.jpg
    % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                    Dload  Upload   Total   Spent    Left  Speed
    100 34509  100 34509    0     0  28.1M      0 --:--:-- --:--:-- --:--:-- 32.9M
    ```
1. Проверка, что файл сохранён
    ```bash
    ll *jpg
    -rw-rw-r-- 1 panarin panarin 34509 апреля 10 11:22 1.jpg
    -rw-rw-r-- 1 panarin panarin 34509 апреля 10 11:45 2.jpg
    ```
1. Проверка контрольных сумм - файл тот же
    ```bash
    md5sum *jpg
    b083d88611c22dcf06f3c5f907d7504c  1.jpg
    b083d88611c22dcf06f3c5f907d7504c  2.jpg
    ```
