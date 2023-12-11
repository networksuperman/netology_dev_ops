## Домашнее задание к занятию «Продвинутые методы работы с Terraform»  

### Задание 1  
Возьмите из демонстрации к лекции готовый код для создания ВМ с помощью remote-модуля.  
Создайте одну ВМ, используя этот модуль. В файле cloud-init.yml необходимо использовать переменную для ssh-ключа вместо хардкода. Передайте ssh-ключ в функцию template_file в блоке vars ={} . Воспользуйтесь примером. Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку.  
Добавьте в файл cloud-init.yml установку nginx.  
Предоставьте скриншот подключения к консоли и вывод команды sudo nginx -t.  

#### Ответ:  
Процесс создания VM  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_01.png)  

Подключение к одной из VM по SSH
```
sudo nginx -t
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_02.png)  

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
```
terraform console
>module.vpc
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_03.png)  


### Задание 3  
Выведите список ресурсов в стейте.  
Полностью удалите из стейта модуль vpc.  
Полностью удалите из стейта модуль vm.  
Импортируйте всё обратно. Проверьте terraform plan. Изменений быть не должно. Приложите список выполненных команд и скриншоты процессы.  

#### Ответ:  
```
terraform state list 
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_04.png)  

```
terraform state rm module.vpc 
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_05.png)  

```
terraform state rm module.test-vm
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_06.png)  

```
terraform import module.vpc.yandex_vpc_network.net_name enp05m086394rdkv82rf
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_07.png)  

```
terraform import module.vpc.yandex_vpc_subnet.subnet_name e9bvoaef382ug0bgecb5 
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_08.png)  

```
terraform import 'module.test-vm.yandex_compute_instance.vm[0]' fhmijvgfs5viutjgrf6g
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_09.png)  

```
terraform import 'module.test-vm.yandex_compute_instance.vm[1]' fhmo3a8fm05f7hp3fkh2
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_10.png)  

```
terraform plan 
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/04/img/ter-04_11.png)  
