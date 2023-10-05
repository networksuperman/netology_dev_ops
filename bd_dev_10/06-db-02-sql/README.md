## Домашнее задание к занятию 2. «SQL»  

### Задача 1  
Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose-манифест.

#### Ответ:  
```
version: '3.9'
services:
  postgres:
    image: postgres:12
    environment:
      - POSTGRES_PASSWORD=postgres
      - POSTGRES_USER=postgres
    volumes:
      - ./data:/var/lib/postgresql/data
      - ./backup:/data/backup/postgres
    ports:
      - "5432:5432"
    restart: always

docker-compose up -d

[root@kuber-node02 ~]# docker-compose ps
NAME              IMAGE         COMMAND                           SERVICE    CREATED          STATUS          PORTS
root-postgres-1   postgres:12   "docker-entrypoint.sh postgres"   postgres   23 seconds ago   Up 20 seconds   0.0.0.0:5432->5432/tcp, :::5432->5432/tcp

```
![]()  

### Задача 2  
В БД из задачи 1:
создайте пользователя test-admin-user и БД test_db
в БД test_db создайте таблицу orders и clients (спeцификация таблиц ниже)
предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
создайте пользователя test-simple-user
предоставьте пользователю test-simple-user права на SELECT/INSERT/UPDATE/DELETE данных таблиц БД test_db

Таблица orders:
id (serial primary key)
наименование (string)
цена (integer)

Подключение к контейнеру с postgresql
```
sudo docker exec -it имя_или_id_контейнера psql -U postgres
```
Создание пользователя test-admin-user и БД test_db
```
CREATE DATABASE test_db;
CREATE USER "test-admin-user" WITH PASSWORD '123';
```
```
postgres=# \connect test_db
```
Создание таблиц orders, clients
```
CREATE TABLE orders (id SERIAL, наименование VARCHAR, цена INT, PRIMARY KEY(id));

CREATE TABLE clients (id SERIAL, "фамилия" VARCHAR,
"страна проживания" VARCHAR, "заказ" INT,
PRIMARY KEY (id), FOREIGN KEY(заказ) REFERENCES orders(id));

CREATE INDEX idx_country ON clients ("страна проживания");
```
Предоставьте привилегии на все операции пользователю test-admin-user на таблицы БД test_db
```
test_db=# GRANT ALL PRIVILEGES ON DATABASE test_db to "test-admin-user";
GRANT
test_db=# GRANT ALL PRIVILEGES ON TABLE orders, clients  to "test-admin-user";
GRANT
```
Создаем еще одного пользователя test-simple-user
```
CREATE USER "test-simple-user" WITH PASSWORD '123';
```
Назначаем для пользователя test-simple-user права на SELECT/INSERT/UPDATE/DELETE этих таблиц БД test_db
```
GRANT SELECT, INSERT, UPDATE, DELETE ON orders, clients TO "test-simple-user";
```
Итоговый список БД
```
test_db=# \list
                                 List of databases
   Name    |  Owner   | Encoding |  Collate   |   Ctype    |   Access privileges
-----------+----------+----------+------------+------------+-----------------------
 postgres  | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
 template0 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.utf8 | en_US.utf8 | =c/postgres          +
           |          |          |            |            | postgres=CTc/postgres
 test_db   | postgres | UTF8     | en_US.utf8 | en_US.utf8 |
(4 rows)
```
```
test_db=# \d orders
                                    Table "public.orders"
    Column    |       Type        | Collation | Nullable |              Default
--------------+-------------------+-----------+----------+------------------------------------
 id           | integer           |           | not null | nextval('orders_id_seq'::regclass)
 наименование | character varying |           |          |
 цена         | integer           |           |          |
Indexes:
    "orders_pkey" PRIMARY KEY, btree (id)
Referenced by:
    TABLE "clients" CONSTRAINT "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```
```
test_db=# \d clients
                                       Table "public.clients"
      Column       |       Type        | Collation | Nullable |               Default
-------------------+-------------------+-----------+----------+-------------------------------------
 id                | integer           |           | not null | nextval('clients_id_seq'::regclass)
 фамилия           | character varying |           |          |
 страна проживания | character varying |           |          |
 заказ             | integer           |           |          |
Indexes:
    "clients_pkey" PRIMARY KEY, btree (id)
    "idx_country" btree ("страна проживания")
Foreign-key constraints:
    "clients_заказ_fkey" FOREIGN KEY ("заказ") REFERENCES orders(id)
```
SQL-запрос для выдачи списка пользователей с правами над таблицами test_db
```
test_db=# SELECT distinct grantee
FROM information_schema.role_table_grants
WHERE table_name in ('orders','clients');
     grantee
------------------
 postgres
 test-admin-user
 test-simple-user
(3 rows)
```
список пользователей с правами над таблицами test_db
```

```
