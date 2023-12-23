## Clickhouse-Vector-Lighthouse Ansible-Playbook
Проект развёртывания инфраструктуры для сбора и анализа логов на основе Clickhouse и Vector и просмотра в Lighthouse.

Playbook разбит на три роли для настройки, соответственно, Clickhouse в качестве БД, Vector в качестве транспорта и Lighthouse в качестве просмотрщика таблицы с логами. В конце исполнения плейбука выдаётся адрес для подключения к Lighthouse, в котором уже прописан адрес и логин с паролем для подключения к Clickhouse.


## Installation
Данный playbook запускается автоматически при использовании совместно с приложенным Terraform.

Для установки используется дистрибутив CentOS 7.

Для выбора версии и архитектуры замените в файлах `group_vars/clickhouse/clickhouse.yml` и `group_vars/vector/vector.yml` соответствующие значения переменных:
```
clickhouse_version: <"version">
clickhouse_arch: <"arch">
```
```
vector_version: <"version">
vector_arch: <"arch">
```

Для выбора порта Lighthouse измените значение переменной `lighthouse_port` в файле `group_vars/lighthouse/lighthouse.yml`

Так как Vector по умолчанию использует пользователя `vector`, на соответствующей(-их) машине(-ах) должен присутствовать данный пользователь, Ansible будет выполнять настройку от его имени. По умолчанию пользователь vector создаётся при инициализации сервера Terraform'ом.

При необходимости можно изменить пользователей, от имени которых подключается Ansible, в параметре `ansible_user` в файле `/inventory/prod.yml`

### Install
Для запуска можно использовать следующую команду после того, как хосты были прописаны в `inventory/prod.yml`:
```shell
ansible-playbook -i inventory/prod.yml site.yml
```

Используются теги `wait` для исключения ожидания готовности серверов для последующих действий, `clickhouse`/`vector`/`lighthouse`/`nginx` для выбора инсталляции только необходимого инструмента

## License
This project is licensed under the [Apache v2.0 License](../LICENSE.txt).
