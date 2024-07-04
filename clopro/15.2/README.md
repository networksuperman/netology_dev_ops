# Домашнее задание к занятию 15.2 «Вычислительные мощности. Балансировщики нагрузки»  

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашних заданий.

---
## Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать бакет Object Storage и разместить в нём файл с картинкой:

 - Создать бакет в Object Storage с произвольным именем (например, _имя_студента_дата_).
 - Положить в бакет файл с картинкой.
 - Сделать файл доступным из интернета.
 
2. Создать группу ВМ в public подсети фиксированного размера с шаблоном LAMP и веб-страницей, содержащей ссылку на картинку из бакета:

 - Создать Instance Group с тремя ВМ и шаблоном LAMP. Для LAMP рекомендуется использовать `image_id = fd827b91d99psvq5fjit`.
 - Для создания стартовой веб-страницы рекомендуется использовать раздел `user_data` в [meta_data](https://cloud.yandex.ru/docs/compute/concepts/vm-metadata).
 - Разместить в стартовой веб-странице шаблонной ВМ ссылку на картинку из бакета.
 - Настроить проверку состояния ВМ.
 
3. Подключить группу к сетевому балансировщику:

 - Создать сетевой балансировщик.
 - Проверить работоспособность, удалив одну или несколько ВМ.
4. (дополнительно)* Создать Application Load Balancer с использованием Instance group и проверкой состояния.

Полезные документы:

- [Compute instance group](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance_group).
- [Network Load Balancer](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/lb_network_load_balancer).
- [Группа ВМ с сетевым балансировщиком](https://cloud.yandex.ru/docs/compute/operations/instance-groups/create-with-balancer).

---

### Решение задания 1.

Поверим настройки утилиты `yc` для работы с Yandex Cloud:
```
$ yc config list
token: xxx
cloud-id: xxx
folder-id: xxx
compute-default-zone: ru-central1-a
```
Получим IAM-токен для работы с Yandex Cloud:
```
yc iam create-token
t1.xxx
```
Сохраним IAM-токен и остальные параметры в соответствующие переменные окружения `yc`:
```
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
export YC_ZONE=$(yc config get compute-default-zone)
```
Обновим Terraform до последней версии. Проверим версию Terraform и убедимся в ее актуальности:
```
terraform --version
Terraform v1.9.0
on windows_amd64
```
Выполним настройку зеркала провайдера Yandex Cloud для Terraform, добавив файл terraform.rc в папке %APPDATA% вашего пользователя. Чтобы узнать абсолютный путь к папке %APPDATA%, выполните команду echo %APPDATA% для cmd или $env:APPDATA для PowerShell
```
provider_installation {
  network_mirror {
    url = "https://terraform-mirror.yandexcloud.net/"
    include = ["registry.terraform.io/*/*"]
  }
  direct {
    exclude = ["registry.terraform.io/*/*"]
  }
}
```
Создадим файл `main.tf` для Terraform с информацией об облачном провайдере:
```
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13"
}

provider "yandex" {
  zone = "ru-central1-a"
}
```
Выполним инициализацию Terraform для работы с Yandex Cloud:
```
terraform init

Initializing the backend...
Initializing provider plugins...
- Finding latest version of yandex-cloud/yandex...
- Installing yandex-cloud/yandex v0.122.0...
- Installed yandex-cloud/yandex v0.122.0 (unauthenticated)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
Дополним файл `main.tf` для Terraform необходимой информацией для создания бакета Object Storage и размещения в нём файла с картинкой:  
Добавим блок для создания нового сервисного аккаунта `sa-bucket`, добавления ему роли `storage.editor` и формирования ключа `accesskey-bucket`:
```
# Bucket
resource "yandex_iam_service_account" "sa-bucket" {
  name        = "sa-bucket"
}
resource "yandex_resourcemanager_folder_iam_member" "roleassignment-storageeditor" {
  folder_id = var.yc_folder_id
  role      = "storage.editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-bucket.id}"
}
resource "yandex_iam_service_account_static_access_key" "accesskey-bucket" {
  service_account_id = yandex_iam_service_account.sa-bucket.id
}
```
Добавим блок для создания нового общедоступного бакета с именем `panarin-netology`:
```
resource "yandex_storage_bucket" "panarin-netology" {
  access_key = yandex_iam_service_account_static_access_key.accesskey-bucket.access_key
  secret_key = yandex_iam_service_account_static_access_key.accesskey-bucket.secret_key
  bucket     = "panarin-netology"
  default_storage_class = "STANDARD"
  acl           = "public-read"
  force_destroy = "true"
  anonymous_access_flags {
    read = true
    list = true
    config_read = true
  }
}
```
Добавим блок для загрузки в бакет с именем `panarin-netology` графического файла `netology.png`:
```
resource "yandex_storage_object" "netology" {
  access_key = yandex_iam_service_account_static_access_key.accesskey-bucket.access_key
  secret_key = yandex_iam_service_account_static_access_key.accesskey-bucket.secret_key
  bucket     = yandex_storage_bucket.panarin-netology.id
  key        = "netology.png"
  source     = "netology.png"
}
```
Дополним файл `main.tf` для Terraform необходимой информацией для создания Instance Group:
Добавим блок для создания нового сервисного аккаунта `sa-group` и добавления ему роли `editor`:
```
resource "yandex_iam_service_account" "sa-group" {
  name        = "sa-group"
}
resource "yandex_resourcemanager_folder_iam_member" "roleassignment-editor" {
  folder_id = var.yc_folder_id
  role      = "editor"
  member    = "serviceAccount:${yandex_iam_service_account.sa-group.id}"
}
```
Опишем создание ресурса Instance Group с именем `group-nlb`:
```
resource "yandex_compute_instance_group" "group-nlb" {
  name               = "group-nlb"
  folder_id          = var.yc_folder_id
  service_account_id = "${yandex_iam_service_account.sa-group.id}"
  instance_template {
    platform_id = "standard-v1"
    resources {
      memory = 2
      cores  = 2
    }
    boot_disk {
      initialize_params {
        image_id = "fd827b91d99psvq5fjit"
      }
    }
    network_interface {
      network_id = "${yandex_vpc_network.network-netology.id}"
      subnet_ids = ["${yandex_vpc_subnet.public.id}"]
    }
    metadata = {
      ssh-keys  = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
      user-data = "#!/bin/bash\n cd /var/www/html\n echo \"<html><h1>The netology web-server with a network load balancer.</h1><img src='https://${yandex_storage_bucket.panarin-netology.bucket_domain_name}/${yandex_storage_object.netology.key}'></html>\" > index.html"
    }
    labels = {
      group = "group-nlb"
    }
  }
  scale_policy {
    fixed_scale {
      size = 3
    }
  }
  allocation_policy {
    zones = [var.yc_zone]
  }
  deploy_policy {
    max_unavailable = 2
    max_expansion   = 1
  }
  load_balancer {
    target_group_name = "target-nlb"
  }
  health_check {
    interval = 15
    timeout = 5
    healthy_threshold = 5
    unhealthy_threshold = 2
    http_options {
      path = "/"
      port = 80
    }
  }
}
```
Дополним файл `main.tf` для Terraform необходимой информацией для создания сетевого балансировщика:
```
# Network Load balancer
resource "yandex_lb_network_load_balancer" "nlb" {
  name = "nlb"
  listener {
    name = "nlb-listener"
    port = 80
    external_address_spec {
      ip_version = "ipv4"
    }
  }
  attached_target_group {
    target_group_id = yandex_compute_instance_group.group-nlb.load_balancer.0.target_group_id
    healthcheck {
      name = "http"
      interval = 10
      timeout = 5
      healthy_threshold = 5
      unhealthy_threshold = 2
      http_options {
        path = "/"
        port = 80        
      }
    }
  }
}
```
Добавим в вывод информацию об IP-адресах для инстансов созданной группы и для сетевого балансировщика, а также ссылку на графический файл в созданном объектном хранилище:
```
output "ipaddress_group-nlb" {
  value = yandex_compute_instance_group.group-nlb.instances[*].network_interface[0].ip_address
}
output "nlb_address" {
  value = yandex_lb_network_load_balancer.nlb.listener.*.external_address_spec[0].*.address
}
output "picture_url" {
  value = "https://${yandex_storage_bucket.panarin-netology.bucket_domain_name}/${yandex_storage_object.netology.key}"
}
