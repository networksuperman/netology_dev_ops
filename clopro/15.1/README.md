# Домашнее задание к занятию «Организация сети»

### Подготовка к выполнению задания

1. Домашнее задание состоит из обязательной части, которую нужно выполнить на провайдере Yandex Cloud, и дополнительной части в AWS (выполняется по желанию). 
2. Все домашние задания в блоке 15 связаны друг с другом и в конце представляют пример законченной инфраструктуры.  
3. Все задания нужно выполнить с помощью Terraform. Результатом выполненного домашнего задания будет код в репозитории. 
4. Перед началом работы настройте доступ к облачным ресурсам из Terraform, используя материалы прошлых лекций и домашнее задание по теме «Облачные провайдеры и синтаксис Terraform». Заранее выберите регион (в случае AWS) и зону.

---
### Задание 1. Yandex Cloud 

**Что нужно сделать**

1. Создать пустую VPC. Выбрать зону.
2. Публичная подсеть.

 - Создать в VPC subnet с названием public, сетью 192.168.10.0/24.
 - Создать в этой подсети NAT-инстанс, присвоив ему адрес 192.168.10.254. В качестве image_id использовать fd80mrhj8fl2oe87o4e1.
 - Создать в этой публичной подсети виртуалку с публичным IP, подключиться к ней и убедиться, что есть доступ к интернету.
3. Приватная подсеть.
 - Создать в VPC subnet с названием private, сетью 192.168.20.0/24.
 - Создать route table. Добавить статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс.
 - Создать в этой приватной подсети виртуалку с внутренним IP, подключиться к ней через виртуалку, созданную ранее, и убедиться, что есть доступ к интернету.

Resource Terraform для Yandex Cloud:

- [VPC subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet).
- [Route table](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_route_table).
- [Compute Instance](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/compute_instance).

---
Решение

Проверим `yc`:
```
yc config list

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
Обновим Terraform до последней версии. Проверим его версию после обновления:
```
terraform -v
Terraform v1.9.0
on windows_amd64
```
Выполним настройку зеркала провайдера Yandex Cloud для Terraform, добавив файл `terraform.rc` в папке %APPDATA% вашего пользователя.
Чтобы узнать абсолютный путь к папке %APPDATA%, выполните команду echo %APPDATA% для cmd или $env:APPDATA для PowerShell
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
Создадим файл `main.tf` для Terraform с информацией об облачном провайдере
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
Дополним файл `main.tf` для Terraform необходимой информацией для создания VPC и публичной подсети в Yandex Cloud:
Добавим блок переменных, определяющих основные параметры Yandex Cloud:
```
# Variables
variable "yc_token" {
  default = "t1.xxx"
}
variable "yc_cloud_id" {
  default = "xxx"
}
variable "yc_folder_id" {
  default = "xxx"
}
variable "yc_zone" {
  default = "ru-central1-a"
} 
```
Уточним информацию об облачном провайдере, используя описанные переменные:
```
provider "yandex" {
  token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone = var.yc_zone
}
```
Опишем создание VPC:
```
# VPC
resource "yandex_vpc_network" "network-netology" {
  name = "network-netology"
}
```
Опишем создание публичной подсети с именем `public`:
```
# Public subnet
resource "yandex_vpc_subnet" "public" {
  name           = "public"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-netology.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}
```
Опишем создание NAT-инстанса с адресом `192.168.10.254` и image_id `fd80mrhj8fl2oe87o4e1`:
```
# NAT instance
resource "yandex_compute_instance" "nat-instance" {
  name = "nat-instance"
  hostname = "nat-instance"
  zone     = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd80mrhj8fl2oe87o4e1"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    ip_address = "192.168.10.254"
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```
Опишем создание виртуальной машины с публичным IP:
```
# Public instance
resource "yandex_compute_instance" "public-instance" {
  name = "public-instance"
  hostname = "public-instance"
  zone     = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd826honb8s0i1jtt6cg"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.public.id
    nat       = true
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```
Добавим в вывод информацию об external IP-адресах для NAT instance и Public instance:
```
output "external_ip_address_public" {
  value = yandex_compute_instance.public-instance.network_interface.0.nat_ip_address
}
output "external_ip_address_nat" {
  value = yandex_compute_instance.nat-instance.network_interface.0.nat_ip_address
}
```
Проверим конфигурацию Terraform для созданного файла `main.tf`:
```
terraform validate
Success! The configuration is valid.
```
Подготовим план для Terraform:
```
terraform plan

-----ВЫВОД-----
Plan: 4 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_nat    = (known after apply)
  + external_ip_address_public = (known after apply)
```
Запустим создание ресурсов с помощью Terraform:
```
terraform apply --auto-approve

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_nat = "84.201.173.13"
external_ip_address_public = "51.250.72.109"
```
Убедимся, что сеть с именем `network-netology` создана:
```
 yc vpc network list
+----------------------+------------------+
|          ID          |       NAME       |
+----------------------+------------------+
|xxxxxxxxxxxxxxxxxxxxx | network-netology |
+----------------------+------------------+
```
Убедимся, что в сети с именем `network-netology` создана подсеть `public`:
```
 yc vpc network --name network-netology list-subnets
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
|          ID          |  NAME   |      FOLDER ID       |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
| xxxxxxxxxxxxxxxxxxxxx | public  |xxxxxxxxxxxxxxxxxxxx | xxxxxxxxxxxxxxxxxxxx |                      | ru-central1-a | [192.168.10.0/24] |
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
```
Убедимся, что созданы виртуальные машины `nat-instance` и `public-instance`:
```
 yc compute instance list
+----------------------+------------------+---------------+---------+---------------+----------------+
|          ID          |       NAME       |    ZONE ID    | STATUS  |  EXTERNAL IP  |  INTERNAL IP   |
+----------------------+------------------+---------------+---------+---------------+----------------+
| xxxxxxxxxxxxxxxxxxxx | public-instance  | ru-central1-a | RUNNING | 51.250.72.109 | 192.168.10.6   |
| xxxxxxxxxxxxxxxxxxxx | nat-instance     | ru-central1-a | RUNNING | 84.201.173.13 | 192.168.10.254 |
+----------------------+------------------+---------------+---------+---------------+----------------+
```
Подключимся к виртуальной машине `public-instance` и проверим наличие доступа в Интернет:
```
ssh ubuntu@51.250.72.109

ubuntu@public-instance:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=58 time=21.6 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=58 time=21.0 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=58 time=21.1 ms
64 bytes from 8.8.8.8: icmp_seq=4 ttl=58 time=21.0 ms
^C
--- 8.8.8.8 ping statistics ---
4 packets transmitted, 4 received, 0% packet loss, time 3004ms
rtt min/avg/max/mdev = 21.012/21.183/21.648/0.269 ms
```
Удалим ресурсы в Yandex Cloud и перейдем к следующей части задания:
```
Destroy complete! Resources: 4 destroyed.
```
Дополним файл `main.tf` для Terraform необходимой информацией для создания приватной подсети в Yandex Cloud:
Опишем создание приватной подсети с именем `private`:
```
# Private subnet
resource "yandex_vpc_subnet" "private" {
  name           = "private"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-netology.id
  route_table_id = yandex_vpc_route_table.netology-routing.id
  v4_cidr_blocks = ["192.168.20.0/24"]
}
```
Опишем создание route table. Добавим статический маршрут, направляющий весь исходящий трафик private сети в NAT-инстанс:
```
# Routing table
resource "yandex_vpc_route_table" "netology-routing" {
  name       = "netology-routing"
  network_id = yandex_vpc_network.network-netology.id
  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = "192.168.10.254"
  }
}
```
Опишем создание виртуальной машины без публичного IP:
```
# Private instance
resource "yandex_compute_instance" "private-instance" {
  name = "private-instance"
  hostname = "private-instance"
  zone     = var.yc_zone
  resources {
    cores  = 2
    memory = 2
  }
  boot_disk {
    initialize_params {
      image_id = "fd8bkgba66kkf9eenpkb"
    }
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.private.id
  }
  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_rsa.pub")}"
  }
}
```
Добавим в вывод информацию о внутреннем IP-адресе для Private instance:
```
output "internal_ip_address_private" {
  value = yandex_compute_instance.private-instance.network_interface.0.ip_address
}
```
Проверим конфигурацию Terraform для обновленного файла `main.tf`:
```
terraform validate
Success! The configuration is valid.
```
Подготовим план для Terraform:
```
terraform plan

Plan: 7 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + external_ip_address_nat     = (known after apply)
  + external_ip_address_public  = (known after apply)
  + internal_ip_address_private = (known after apply)
```
Запустим создание ресурсов с помощью Terraform:
```
terraform apply --auto-approve

Apply complete! Resources: 7 added, 0 changed, 0 destroyed.

Outputs:

external_ip_address_nat = "84.201.134.247"
external_ip_address_public = "51.250.1.121"
internal_ip_address_private = "192.168.20.19"
```
Убедимся, что в сети с именем `network-netology` созданы подсети `public` и `private` (при этом `private` с `route table`):
```
 yc vpc network --name network-netology list-subnets
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
|          ID          |  NAME   |      FOLDER ID       |      NETWORK ID      |    ROUTE TABLE ID    |     ZONE      |       RANGE       |
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
| xxxxxxxxxxxxxxxxxxxx | private | xxxxxxxxxxxxxxxxxxxx | xxxxxxxxxxxxxxxxxxxx | xxxxxxxxxxxxxxxxxxxx | ru-central1-a | [192.168.20.0/24] |
| xxxxxxxxxxxxxxxxxxxx | public  | xxxxxxxxxxxxxxxxxxxx | xxxxxxxxxxxxxxxxxxxx |                      | ru-central1-a | [192.168.10.0/24] |
+----------------------+---------+----------------------+----------------------+----------------------+---------------+-------------------+
```
Убедимся, что созданы виртуальные машины `nat-instance`, `public-instance` и `private-instance`:
```
  yc compute instance list
+----------------------+------------------+---------------+---------+----------------+----------------+
|          ID          |       NAME       |    ZONE ID    | STATUS  |  EXTERNAL IP   |  INTERNAL IP   |
+----------------------+------------------+---------------+---------+----------------+----------------+
| xxxxxxxxxxxxxxxxxxxx | public-instance  | ru-central1-a | RUNNING | 51.250.1.121   | 192.168.10.3   |
| xxxxxxxxxxxxxxxxxxxx | private-instance | ru-central1-a | RUNNING |                | 192.168.20.19  |
| xxxxxxxxxxxxxxxxxxxx | nat-instance     | ru-central1-a | RUNNING | 84.201.134.247 | 192.168.10.254 |
+----------------------+------------------+---------------+---------+----------------+----------------+
```
Видим, что виртуальная машина `private-instance` не имеет внешнего IP-адреса. Так и должно быть. Подключение к данной виртуальной машине выполним через виртуальную машину `public-instance`, скопировав на нее приватный ключ ssh:
```
scp ~/.ssh/id_ed25519 ubuntu@51.250.1.121:/home/ubuntu/.ssh/
id_ed25519    

ssh ubuntu@51.250.1.121

ssh 192.168.20.19

ubuntu@private-instance:~$ ping 8.8.8.8
PING 8.8.8.8 (8.8.8.8) 56(84) bytes of data.
64 bytes from 8.8.8.8: icmp_seq=1 ttl=54 time=17.4 ms
64 bytes from 8.8.8.8: icmp_seq=2 ttl=54 time=16.3 ms
64 bytes from 8.8.8.8: icmp_seq=3 ttl=54 time=16.2 ms
^C
--- 8.8.8.8 ping statistics ---
3 packets transmitted, 3 received, 0% packet loss, time 2003ms
rtt min/avg/max/mdev = 16.171/16.610/17.358/0.531 ms
```
Удалим все созданные ресурсы в Yandex Cloud:
```
terraform destroy --auto-approve

Destroy complete! Resources: 7 destroyed.
```
Ссылка на полный файл [main.tf](./configs/main.tf)
