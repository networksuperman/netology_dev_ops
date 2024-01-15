## Clickhouse-Vector-Lighthouse Ansible-Playbook
Проект развёртывания инфраструктуры для сбора и анализа логов на основе Clickhouse и Vector и просмотра в Lighthouse.

Playbook использует три роли для настройки, соответственно, [Clickhouse](https://github.com/AlexeySetevoi/ansible-clickhouse/tree/1.13) в качестве БД, [Vector](https://github.com/networksuperman/vector-role) в качестве транспорта и [Lighthouse](https://github.com/networksuperman/lighthouse-role) в качестве просмотрщика таблицы с логами. В конце исполнения плейбука выдаётся адрес для подключения к Lighthouse, в котором уже прописан адрес и логин с паролем для подключения к Clickhouse.


## Installation
Данный playbook запускается автоматически при использовании совместно с приложенным Terraform.

Для установки используется дистрибутив CentOS 7.

### Install
Для отдельного запуска можно использовать следующую команду после того, как хосты были прописаны в `inventory/prod.yml` и подгружены зависимости:
```shell
ansible-playbook -i inventory/prod.yml site.yml
```

Используются теги `wait` для исключения ожидания готовности серверов для последующих действий, `clickhouse`/`vector`/`lighthouse`/`nginx` для выбора инсталляции только необходимого инструмента

## License
This project is licensed under the [MIT License](LICENSE).
