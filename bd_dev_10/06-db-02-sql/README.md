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

docker-compose ps
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

```
sudo docker exec -it id или имя контейнера psql -U postgres
```
```
CREATE USER "test-admin-user" WITH LOGIN;
CREATE DATABASE test_db;
CREATE TABLE orders (
	id SERIAL PRIMARY KEY, 
	наименование TEXT, 
	цена INT
);

CREATE TABLE clients (
	id SERIAL PRIMARY KEY, 
	фамилия TEXT, 
	"страна проживания" TEXT, 
	заказ INT REFERENCES orders (id)
);

CREATE INDEX ON clients ("страна проживания");

GRANT ALL ON TABLE clients, orders TO "test-admin-user";
CREATE USER "test-simple-user" WITH LOGIN;
GRANT SELECT,INSERT,UPDATE,DELETE ON TABLE clients,orders TO "test-simple-user";
```
Таблица clients:
id (serial primary key)
фамилия (string)
страна проживания (string, index)
заказ (foreign key orders)


