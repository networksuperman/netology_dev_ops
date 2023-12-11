## Домашнее задание к занятию «Продвинутые методы работы с Terraform»  

### Задание 1  
Возьмите из демонстрации к лекции готовый код для создания ВМ с помощью remote-модуля.  
Создайте одну ВМ, используя этот модуль. В файле cloud-init.yml необходимо использовать переменную для ssh-ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} . Воспользуйтесь примером. Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку.  
Добавьте в файл cloud-init.yml установку nginx.  
Предоставьте скриншот подключения к консоли и вывод команды sudo nginx -t.  

#### Ответ:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/1_1.png)  

### Задание 2  
Напишите локальный модуль vpc, который будет создавать 2 ресурса: одну сеть и одну подсеть в зоне, объявленной при вызове модуля, например: ru-central1-a.  
Вы должны передать в модуль переменные с названием сети, zone и v4_cidr_blocks.  
Модуль должен возвращать в root module с помощью output информацию о yandex_vpc_subnet. Пришлите скриншот информации из terraform console о своем модуле. Пример: > module.vpc_dev  
Замените ресурсы yandex_vpc_network и yandex_vpc_subnet созданным модулем. Не забудьте передать необходимые параметры сети из модуля vpc в модуль с виртуальной машиной.  
Откройте terraform console и предоставьте скриншот содержимого модуля. Пример: > module.vpc_dev.  
Сгенерируйте документацию к модулю с помощью terraform-docs.  
Пример вызова  
```
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
```

#### Ответ:  
[Документация](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/src/modules/vpc/README.md)  

### Задание 3  
Выведите список ресурсов в стейте.  
Полностью удалите из стейта модуль vpc.  
Полностью удалите из стейта модуль vm.  
Импортируйте всё обратно. Проверьте terraform plan. Изменений быть не должно. Приложите список выполненных команд и скриншоты процессы.  

#### Ответ:  
```
$ terraform state list

data.template_file.cloudinit
module.test-vm.data.yandex_compute_image.my_image
module.test-vm.yandex_compute_instance.vm[0]
module.test-vm.yandex_compute_instance.vm[1]
module.vpc.yandex_vpc_network.develop
module.vpc.yandex_vpc_subnet.develop


$ terraform state rm module.vpc
Removed module.vpc.yandex_vpc_network.develop
Removed module.vpc.yandex_vpc_subnet.develop
Successfully removed 2 resource instance(s).


$ terraform import module.vpc.yandex_vpc_network.develop enps7vmdpccco28m616h

data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=3b274ebe0589664b67c9ae4f3156681860281a0af2b4180b9e091aa7152a1e55]
module.vpc.yandex_vpc_network.develop: Importing from ID "enps7vmdpccco28m616h"...
module.vpc.yandex_vpc_network.develop: Import prepared!
  Prepared yandex_vpc_network for import
module.vpc.yandex_vpc_network.develop: Refreshing state... [id=enps7vmdpccco28m616h]
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.test-vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd8qssu7gclkmoi9flt4]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.


$ terraform import module.vpc.yandex_vpc_subnet.develop e2l2i7nau46tf4jn3av2                     
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=3b274ebe0589664b67c9ae4f3156681860281a0af2b4180b9e091aa7152a1e55]
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc.yandex_vpc_subnet.develop: Importing from ID "e2l2i7nau46tf4jn3av2"...
module.vpc.yandex_vpc_subnet.develop: Import prepared!
  Prepared yandex_vpc_subnet for import
module.vpc.yandex_vpc_subnet.develop: Refreshing state... [id=e2l2i7nau46tf4jn3av2]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 0s [id=fd8qssu7gclkmoi9flt4]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.


$ terraform plan                                                            
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=3b274ebe0589664b67c9ae4f3156681860281a0af2b4180b9e091aa7152a1e55]
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc.yandex_vpc_network.develop: Refreshing state... [id=enps7vmdpccco28m616h]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 0s [id=fd8qssu7gclkmoi9flt4]
module.vpc.yandex_vpc_subnet.develop: Refreshing state... [id=e2l2i7nau46tf4jn3av2]
module.test-vm.yandex_compute_instance.vm[0]: Refreshing state... [id=epdtqv8tdnaf8k78fpti]
module.test-vm.yandex_compute_instance.vm[1]: Refreshing state... [id=epd96l2fgo7f7vfb2o4t]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.

```

Дополнительные задания (со звёздочкой*)  
Настоятельно рекомендуем выполнять все задания со звёздочкой. Они помогут глубже разобраться в материале.  
Задания со звёздочкой дополнительные, не обязательные к выполнению и никак не повлияют на получение вами зачёта по этому домашнему заданию.  

### Задание 4*
Измените модуль vpc так, чтобы он мог создать подсети во всех зонах доступности, переданных в переменной типа list(object) при вызове модуля.  
Пример вызова  
```
module "vpc_prod" {
  source       = "./vpc"
  env_name     = "production"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
    { zone = "ru-central1-b", cidr = "10.0.2.0/24" },
    { zone = "ru-central1-c", cidr = "10.0.3.0/24" },
  ]
}

module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  subnets = [
    { zone = "ru-central1-a", cidr = "10.0.1.0/24" },
  ]
}
```
Предоставьте код, план выполнения, результат из консоли YC.

#### Ответ:  
Код можно посмотреть [здесь](https://github.com/networksuperman/netology_dev_ops/tree/main/ter-homeworks/04/src/modules/vpc). Отдельно его не выделял. [Ссылка](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/src/tfplan.txt) на план выполнения  
