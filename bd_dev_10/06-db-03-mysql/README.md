## Домашнее задание к занятию 3. «MySQL»  

### Задача 1  
Используя Docker, поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.  
Изучите бэкап БД и восстановитесь из него.  
Перейдите в управляющую консоль mysql внутри контейнера.  
Используя команду \h, получите список управляющих команд.  
Найдите команду для выдачи статуса БД и приведите в ответе из её вывода версию сервера БД.  
Подключитесь к восстановленной БД и получите список таблиц из этой БД.  
Приведите в ответе количество записей с price > 300.  
В следующих заданиях мы будем продолжать работу с этим контейнером.  

#### Ответ:  
Создаем docker-compose.yml

```
version: '3.5'
services:
  mysql:
    image: mysql:8
    environment:
      - MYSQL_ROOT_PASSWORD=root
      - MYSQL_DATABASE=test_db
    volumes:
      - ./data:/var/lib/mysql
      - ./backup:/data/backup/mysql
    ports:
      - "3306:3306"
    restart: always
```
```
docker-compose  ps
NAME                  IMAGE     COMMAND                         SERVICE   CREATED              STATUS          PORTS
task3-mysql-mysql-1   mysql:8   "docker-entrypoint.sh mysqld"   mysql     About a minute ago   Up 43 seconds   0.0.0.0:3306->3306/tcp, :::3306->3306/tcp, 33060/tcp
```
Восстанавливаем бэкап
```
docker exec -it task3-mysql-mysql-1  bash

mysql -u root -p test_db < /data/backup/mysql/test_dump.sql
```
Команда для выдачи статуса БД
```
mysql> status
--------------
mysql  Ver 8.1.0 for Linux on x86_64 (MySQL Community Server - GPL)

Connection id:          12
Current database:
Current user:           root@localhost
SSL:                    Not in use
Current pager:          stdout
Using outfile:          ''
Using delimiter:        ;
Server version:         8.1.0 MySQL Community Server - GPL
Protocol version:       10
Connection:             Localhost via UNIX socket
Server characterset:    utf8mb4
Db     characterset:    utf8mb4
Client characterset:    latin1
Conn.  characterset:    latin1
UNIX socket:            /var/run/mysqld/mysqld.sock
Binary data as:         Hexadecimal
Uptime:                 46 min 29 sec

Threads: 2  Questions: 60  Slow queries: 0  Opens: 139  Flush tables: 3  Open tables: 57  Queries per second avg: 0.021
--------------
```
Подключение к БД и получение списка БД
```
mysql> use test_db;
Reading table information for completion of table and column names
You can turn off this feature to get a quicker startup with -A

Database changed

mysql> SHOW TABLES;
+-------------------+
| Tables_in_test_db |
+-------------------+
| orders            |
+-------------------+
1 row in set (0.01 sec)
```
Получение количества записей с price > 300.
```
mysql> SELECT * FROM orders WHERE price > 300;
+----+----------------+-------+
| id | title          | price |
+----+----------------+-------+
|  2 | My little pony |   500 |
+----+----------------+-------+
1 row in set (0.00 sec)
```

### Задача 2  
Создайте пользователя test в БД c паролем test-pass, используя:  
плагин авторизации mysql_native_password  
срок истечения пароля — 180 дней  
количество попыток авторизации — 3  
максимальное количество запросов в час — 100  
аттрибуты пользователя:  
Фамилия "Pretty"  
Имя "James".  
Предоставьте привелегии пользователю test на операции SELECT базы test_db.  
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES, получите данные по пользователю test и приведите в ответе к задаче.  

#### Ответ:  
Создание пользователя
```
CREATE USER 'test'@'localhost'
IDENTIFIED WITH mysql_native_password BY 'test-pass' 
WITH MAX_QUERIES_PER_HOUR 100
PASSWORD EXPIRE INTERVAL 180 DAY
FAILED_LOGIN_ATTEMPTS 3
ATTRIBUTE '{"fname": "James", "lname": "Pretty"}';
```
Предоставление привелегий пользователю test на операции SELECT базы test_db
```
GRANT SELECT ON test_db.* TO 'test'@'localhost';
```
Данные по пользователю test
```
SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';

+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
```

### Задача 3  
Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.  
Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.  
Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:  
на MyISAM,  
на InnoDB.  

#### Ответ:  
Установите профилирование SET profiling = 1. Изучите вывод профилирования команд SHOW PROFILES;.
```
mysql> use test_db
Database changed
mysql> SET profiling = 1;
Query OK, 0 rows affected, 1 warning (0.00 sec)

mysql> show profiles;
+----------+------------+-------------------+
| Query_ID | Duration   | Query             |
+----------+------------+-------------------+
|        1 | 0.02399225 | SELECT DATABASE() |
|        2 | 0.00029950 | SET profiling = 1 |
+----------+------------+-------------------+
2 rows in set, 1 warning (0.00 sec)
```
Исследуйте, какой engine используется в таблице БД test_db и приведите в ответе.
```
mysql> SELECT TABLE_NAME,
    ->        ENGINE
    -> FROM   information_schema.TABLES
    -> WHERE  TABLE_SCHEMA = 'test_db';
+------------+--------+
| TABLE_NAME | ENGINE |
+------------+--------+
| orders     | InnoDB |
+------------+--------+
1 row in set (0.00 sec)
```
Измените engine и приведите время выполнения и запрос на изменения из профайлера в ответе:
на MyISAM
на InnoDB
```
mysql> alter table orders engine = myisam;
Query OK, 5 rows affected (0.87 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> alter table orders engine = innodb;
Query OK, 5 rows affected (0.68 sec)
Records: 5  Duplicates: 0  Warnings: 0

mysql> show profiles;
+----------+------------+------------------------------------+
| Query_ID | Duration   | Query                              |
+----------+------------+------------------------------------+
|       10 | 0.87218275 | alter table orders engine = myisam |
|       11 | 0.68286425 | alter table orders engine = innodb |
+----------+------------+------------------------------------+
2 rows in set, 1 warning (0.00 sec)
```

### Задача 4  
Изучите файл my.cnf в директории /etc/mysql.  
Измените его согласно ТЗ (движок InnoDB):  
скорость IO важнее сохранности данных;  
нужна компрессия таблиц для экономии места на диске;  
размер буффера с незакомиченными транзакциями 1 Мб;  
буффер кеширования 30% от ОЗУ;  
размер файла логов операций 100 Мб.  
Приведите в ответе изменённый файл my.cnf.  

#### Ответ:  
```
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Custom config should go here
!includedir /etc/mysql/conf.d/

innodb_flush_method = O_DSYN
innodb_file_per_table = 1
innodb_log_buffer_size = 1M
innodb_buffer_pool_size = 1G
innodb_log_file_size = 100M
```
