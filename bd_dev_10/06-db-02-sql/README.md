## Домашнее задание к занятию 2. «SQL»  

### Задача 1  
Используя Docker, поднимите инстанс PostgreSQL (версию 12) c 2 volume, в который будут складываться данные БД и бэкапы.
Приведите получившуюся команду или docker-compose-манифест.

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
test_db=# SELECT grantee, table_name, privilege_type
FROM information_schema.role_table_grants
WHERE table_name in ('orders','clients');
     grantee      | table_name | privilege_type
------------------+------------+----------------
 postgres         | orders     | INSERT
 postgres         | orders     | SELECT
 postgres         | orders     | UPDATE
 postgres         | orders     | DELETE
 postgres         | orders     | TRUNCATE
 postgres         | orders     | REFERENCES
 postgres         | orders     | TRIGGER
 test-simple-user | orders     | INSERT
 test-simple-user | orders     | SELECT
 test-simple-user | orders     | UPDATE
 test-simple-user | orders     | DELETE
 test-admin-user  | orders     | INSERT
 test-admin-user  | orders     | SELECT
 test-admin-user  | orders     | UPDATE
 test-admin-user  | orders     | DELETE
 test-admin-user  | orders     | TRUNCATE
 test-admin-user  | orders     | REFERENCES
 test-admin-user  | orders     | TRIGGER
 postgres         | clients    | INSERT
 postgres         | clients    | SELECT
 postgres         | clients    | UPDATE
 postgres         | clients    | DELETE
 postgres         | clients    | TRUNCATE
 postgres         | clients    | REFERENCES
 postgres         | clients    | TRIGGER
 test-simple-user | clients    | INSERT
 test-simple-user | clients    | SELECT
 test-simple-user | clients    | UPDATE
 test-simple-user | clients    | DELETE
 test-admin-user  | clients    | INSERT
 test-admin-user  | clients    | SELECT
 test-admin-user  | clients    | UPDATE
 test-admin-user  | clients    | DELETE
 test-admin-user  | clients    | TRUNCATE
 test-admin-user  | clients    | REFERENCES
 test-admin-user  | clients    | TRIGGER
(36 rows)
```
### Задача 3
Используя SQL синтаксис - наполните таблицы следующими тестовыми данными:

Таблица orders

Наименование	цена
Шоколад	10
Принтер	3000
Книга	500
Монитор	7000
Гитара	4000

Добавление данных в таблицу orders
```
INSERT INTO orders (наименование, цена )
VALUES 
    ('Шоколад', '10'),
    ('Принтер', '3000'),
    ('Книга', '500'),
    ('Монитор', '7000'),
    ('Гитара', '4000')
;
```
Добавление данных в таблицу clients
```
INSERT INTO clients ("фамилия", "страна проживания")
VALUES 
    ('Иванов Иван Иванович', 'USA'),
    ('Петров Петр Петрович', 'Canada'),
    ('Иоганн Себастьян Бах', 'Japan'),
    ('Ронни Джеймс Дио', 'Russia'),
    ('Ritchie Blackmore', 'Russia')
;
```
Используя SQL синтаксис:

вычислите количество записей для каждой таблицы
приведите в ответе:
запросы
результаты их выполнения.
```
test_db=# SELECT 'orders' AS name_table,  COUNT(*) AS number_rows FROM orders
UNION ALL
SELECT 'clients' AS name_table,  COUNT(*) AS number_rows  FROM clients;
 name_table | number_rows
------------+-------------
 orders     |           5
 clients    |           5
(2 rows)
```

### Задача 4


