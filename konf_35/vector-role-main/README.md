vector-role
=========

Role for installation and configure Vector.

Role Variables
--------------

| Vars                    | Description                                                   |
| ----------------------- | ------------------------------------------------------------- |
| vector_version          | Version of Vector to install                                  |
| vector_arch             | Architecture of node system                                   |
| vector_logs_path        | Directory with logs to watch                                  |
| vector_config_path      | Directory with Ansible's generated Vector config              |
| vector_create_test_file | Create or not test log file to watch                          |
| clickhouse_http_port    | Clickhouse port to connect via http                           |
| clickhouse_ipv4         | Clickhouse external or internal ip                                        |
| clickhouse_db           | Clickhouse database to connect                                |
| clickhouse_table        | Clickhouse ... guess what ... table!                          |
| clickhouse_user         | With that user Vector tries to connect to Clickhouse database |
| clickhouse_password     | Password for this user                                        |

Example Playbook
----------------

```yaml
    - hosts: vector
      roles:
         - { role: vector-role }
```

License
-------

MIT

Author Information
------------------

Nikita Bulgakov
