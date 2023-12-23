## Clickhouse-Vector Ansible-Playbook
Проект развёртывания инфраструктуры для сбора и анализа логов на основе Clickhouse и Vector

## Installation
Данный playbook запускается автоматически при использовании совместно с приложенным Terraform

Для установки используется дистрибутив CentOS 7.

Для выбора версии и архитектуры замените в файлах `group_vars/clickhouse/clickhouse.yml` и `group_vars/vector/vector.yml` соответствующие переменные:
```
clickhouse_version: <"version">
clickhouse_arch: <"arch">
```
```
vector_version: <"version">
vector_arch: <"arch">
```

Так как Vector по умолчанию использует пользователя `vector`, на соответствующей(-их) машине(-ах) должен присутствовать данный пользователь, Ansible будет выполнять настройку от его имени.

При необходимости можно изменить пользователей, от имени которых подключается Ansible, в параметре `ansible_user` в файле `/inventory/prod.yml`

### Install
Для запуска можно использовать следующую команду после того, как хосты были прописаны в `/inventory/prod.yml`:
```shell
ansible-playbook -i /inventory/prod.yml site.yml
```

## License
This project is licensed under the [Apache v2.0 License](../LICENSE.txt).
