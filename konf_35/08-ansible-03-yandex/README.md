[Задание](https://github.com/netology-code/mnt-homeworks/blob/d1adf637051ac1f5fdc71e8ed9563cc8f5a59505/08-ansible-03-yandex/README.md)

---

# Домашнее задание к занятию 3 «Использование Ansible»

## Подготовка к выполнению

1. Подготовьте в Yandex Cloud три хоста: для `clickhouse`, для `vector` и для `lighthouse`.
2. Репозиторий LightHouse находится [по ссылке](https://github.com/VKCOM/lighthouse).

## Основная часть

1. Допишите playbook: нужно сделать ещё один play, который устанавливает и настраивает LightHouse.
2. При создании tasks рекомендую использовать модули: `get_url`, `template`, `yum`, `apt`.
3. Tasks должны: скачать статику LightHouse, установить Nginx или любой другой веб-сервер, настроить его конфиг для открытия LightHouse, запустить веб-сервер.
4. Подготовьте свой inventory-файл `prod.yml`.
5. Запустите `ansible-lint site.yml` и исправьте ошибки, если они есть.
6. Попробуйте запустить playbook на этом окружении с флагом `--check`.
7. Запустите playbook на `prod.yml` окружении с флагом `--diff`. Убедитесь, что изменения на системе произведены.
8. Повторно запустите playbook с флагом `--diff` и убедитесь, что playbook идемпотентен.
9. Подготовьте README.md-файл по своему playbook. В нём должно быть описано: что делает playbook, какие у него есть параметры и теги.
10. Готовый playbook выложите в свой репозиторий, поставьте тег `08-ansible-03-yandex` на фиксирующий коммит, в ответ предоставьте ссылку на него.

---

## Решение:
см. [код](./Code).

В Terraform создаются машины на базе CentOS 7 в Yandex Cloud, в cloud-init сразу создаются соответствующие пользователи и устанавливается epel для машины с Lighthouse. Файл inventory для Ansible прокидывается через шаблон `.tftpl`.

Команды для запуска Terraform стандартные: `terraform init` -> `terraform plan` -> `terraform apply`

Можно использовать удалённый state, для этого раскомментируйте строки 13-24 в файле `providers.tf` 

Не забудьте вставить свои значения в файл `personal.auto.tfvars.example` и переименовать его, убрав `.example`

Ключ SSH для подключения к хостам используется лежащий по адресу `~/.ssh/id_ed25519(.pub)`. Если у вас другой - создайте новый командой `ssh-keygen -t ed25519` или замените его в файлах `main.tf` и `ansible.tf`

[Описание инфрастуктуры](./Code/terraform/README.md), сформированное в terraform-docs

[Описание ansible-playbook](./Code/playbook/README.md) 

---