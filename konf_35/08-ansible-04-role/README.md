[Задание](https://github.com/netology-code/mnt-homeworks/blob/74007ce7e4abdf12f6bafaf5792657d17dd57840/08-ansible-04-role/README.md)

---

# Домашнее задание к занятию 4 «Работа с roles»

## Подготовка к выполнению

1. * Необязательно. Познакомьтесь с [LightHouse](https://youtu.be/ymlrNlaHzIY?t=929).
2. Создайте два пустых публичных репозитория в любом своём проекте: vector-role и lighthouse-role.
3. Добавьте публичную часть своего ключа к своему профилю на GitHub.

## Основная часть

Ваша цель — разбить ваш playbook на отдельные roles. 

Задача — сделать roles для ClickHouse, Vector и LightHouse и написать playbook для использования этих ролей. 

Ожидаемый результат — существуют три ваших репозитория: два с roles и один с playbook.

**Что нужно сделать**

1. Создайте в старой версии playbook файл `requirements.yml` и заполните его содержимым:

   ```yaml
   ---
     - src: git@github.com:AlexeySetevoi/ansible-clickhouse.git
       scm: git
       version: "1.13"
       name: clickhouse 
   ```

2. При помощи `ansible-galaxy` скачайте себе эту роль.
3. Создайте новый каталог с ролью при помощи `ansible-galaxy role init vector-role`.
4. На основе tasks из старого playbook заполните новую role. Разнесите переменные между `vars` и `default`. 
5. Перенести нужные шаблоны конфигов в `templates`.
6. Опишите в `README.md` обе роли и их параметры. Пример качественной документации ansible role [по ссылке](https://github.com/cloudalchemy/ansible-prometheus).
7. Повторите шаги 3–6 для LightHouse. Помните, что одна роль должна настраивать один продукт.
8. Выложите все roles в репозитории. Проставьте теги, используя семантическую нумерацию. Добавьте roles в `requirements.yml` в playbook.
9. Переработайте playbook на использование roles. Не забудьте про зависимости LightHouse и возможности совмещения `roles` с `tasks`.
10. Выложите playbook в репозиторий.
11. В ответе дайте ссылки на оба репозитория с roles и одну ссылку на репозиторий с playbook.

---

## Решение:
см. [код](./Code).

В Terraform создаются машины на базе CentOS 7 в Yandex Cloud, в cloud-init сразу создаются соответствующие пользователи и устанавливается epel для машины с Lighthouse. Файл inventory для Ansible прокидывается через шаблон `.tftpl`.

Команды для запуска Terraform стандартные: `terraform init` -> `terraform plan` -> `terraform apply`

Используется удалённый state, если он не нужен, закомментируйте строки 13-24 в файле `providers.tf` 

Не забудьте вставить свои значения в файл `personal.auto.tfvars.example` и переименовать его, убрав `.example`

Ключ SSH для подключения к хостам используется лежащий по адресу `~/.ssh/id_ed25519(.pub)`. Если у вас другой - создайте новый командой `ssh-keygen -t ed25519` или замените его в файлах `main.tf` и `ansible.tf`

[Описание инфрастуктуры](./Code/terraform/README.md), сформированное в terraform-docs

[Описание ansible-playbook](./Code/playbook/README.md) 

---