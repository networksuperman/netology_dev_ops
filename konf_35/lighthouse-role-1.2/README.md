lighthouse-role
=========

Role for installation and configure VK Lighthouse.

Role Variables
--------------

| Vars                 | Description                                                 |
| -------------------- | ----------------------------------------------------------- |
| lighthouse_http_port | Port where to connect to Lighthouse                         |
| clickhouse_ipv4      | Clickhouse external ip                                      |
| clickhouse_http_port | Clickhouse port where Lighthouse tries to connect with      |
| clickhouse_user      | With that user you tries to connect to Clickhouse databases |
| clickhouse_password  | Password for this user                                      |

Example Playbook
----------------

```yaml
    - hosts: lighthouse
      roles:
         - { role: lighthouse-role }
```

License
-------

MIT

Author Information
------------------

Nikita Bulgakov
