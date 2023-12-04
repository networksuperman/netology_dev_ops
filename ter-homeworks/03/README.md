## Домашнее задание к занятию «Управляющие конструкции в коде Terraform»  

[Код](https://github.com/networksuperman/netology_dev_ops/tree/main/ter-homeworks/03/src)  

### Задание 1  
Изучите проект.  
Заполните файл personal.auto.tfvars.  
Инициализируйте проект, выполните код. Он выполнится, даже если доступа к preview нет.  
Примечание. Если у вас не активирован preview-доступ к функционалу «Группы безопасности» в Yandex Cloud, запросите доступ у поддержки облачного провайдера. Обычно его выдают в течение 24-х часов.
Приложите скриншот входящих правил «Группы безопасности» в ЛК Yandex Cloud или скриншот отказа в предоставлении доступа к preview-версии.  

#### Ответ:  
ЛК Yandex Cloud «Группы безопасности»  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/img/7_3_2.png)  


### Задание 2  
- Создайте файл count-vm.tf. Опишите в нём создание двух одинаковых ВМ web-1 и web-2 (не web-0 и web-1) с минимальными параметрами, используя мета-аргумент count loop. Назначьте ВМ созданную в первом задании группу безопасности.(как это сделать узнайте в документации провайдера yandex/compute_instance )

[count-vm.tf](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/src/count-vm.tf)  

- Создайте файл for_each-vm.tf. Опишите в нём создание двух ВМ для баз данных с именами "main" и "replica" разных по cpu/ram/disk , используя мета-аргумент for_each loop. Используйте для обеих ВМ одну общую переменную типа:  
variable "each_vm" {  
  type = list(object({  vm_name=string, cpu=number, ram=number, disk=number }))  
}  
При желании внесите в переменную все возможные параметры. ВМ из пункта 2.1 должны создаваться после создания ВМ из пункта 2.2.

[for_each-vm.tf](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/src/for_each-vm.tf)  

- Используйте функцию file в local-переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего использования в блоке metadata, взятому из ДЗ 2.
- 
[locals.tf](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/src/locals.tf)  

- Инициализируйте проект, выполните код.  
ЛК Yandex Cloud с созданными ВМ    
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/img/7_3_3.png)

- Подключения к консоли ВМ через ssh
```
ssh ubuntu@51.250.1.206
The authenticity of host '51.250.1.206 (51.250.1.206)' can't be established.
ED25519 key fingerprint is SHA256:k0tuXwS/gR9y5+u86hWcZQYljbSHwyRfG/eCf2ReSEE.
This key is not known by any other names.
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '51.250.1.206' (ED25519) to the list of known hosts.
Welcome to Ubuntu 20.04.6 LTS (GNU/Linux 5.4.0-162-generic x86_64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/advantage

The programs included with the Ubuntu system are free software;
the exact distribution terms for each program are described in the
individual files in /usr/share/doc/*/copyright.

Ubuntu comes with ABSOLUTELY NO WARRANTY, to the extent permitted by
applicable law.

To run a command as administrator (user "root"), use "sudo <command>".
See "man sudo_root" for details.

ubuntu@fhm9ddiav10dehnn0n7k:~$ uname -a
Linux fhm9ddiav10dehnn0n7k 5.4.0-162-generic #179-Ubuntu SMP Mon Dec 04 20:12:18 UTC 2023 x86_64 x86_64 x86_64 GNU/Linux
ubuntu@fhm9ddiav10dehnn0n7k:~$ exit
logout
Connection to 51.250.1.206 closed. 
```

### Задание 3  
Создайте 3 одинаковых виртуальных диска размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count в файле disk_vm.tf .  
Создайте в том же файле одиночную(использовать count или for_each запрещено из-за задания №4) ВМ c именем "storage" . Используйте блок dynamic secondary_disk{..} и мета-аргумент for_each для подключения созданных вами дополнительных дисков.  

#### Ответ:  
[disk_vm.tf](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/src/disk_vm.tf)  

- ЛК Yandex Cloud с созданной ВМ
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/img/7_3_3_1.png)  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/img/7_3_3_2.png)  

### Задание 4  
В файле ansible.tf создайте inventory-файл для ansible. Используйте функцию tepmplatefile и файл-шаблон для создания ansible inventory-файла из лекции. Готовый код возьмите из демонстрации к лекции demonstration2. Передайте в него в качестве переменных группы виртуальных машин из задания 2.1, 2.2 и 3.2, т. е. 5 ВМ.  
Инвентарь должен содержать 3 группы и быть динамическим, т. е. обработать как группу из 2-х ВМ, так и 999 ВМ.  
Добавьте в инвентарь переменную fqdn.  
```
[webservers]  
web-1 ansible_host=<внешний ip-адрес> fqdn=<имя виртуальной машины>.<регион>.internal  
web-2 ansible_host=<внешний ip-адрес> fqdn=<имя виртуальной машины>.<регион>.internal  

[databases]  
main ansible_host=<внешний ip-адрес> fqdn=<имя виртуальной машины>.<регион>.internal  
replica ansible_host<внешний ip-адрес> fqdn=<имя виртуальной машины>.<регион>.internal  

[storage]  
storage ansible_host=<внешний ip-адрес> fqdn=<имя виртуальной машины>.<регион>.internal  
```

Выполните код. Приложите скриншот получившегося файла.
Для общего зачёта создайте в вашем GitHub-репозитории новую ветку terraform-03. Закоммитьте в эту ветку свой финальный код проекта, пришлите ссылку на коммит.
Удалите все созданные ресурсы.

#### Ответ:  
[ansible.tf](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/src/ansible.tf)  
[hosts.cfg](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/src/hosts.cfg)    
[hosts.tftpl](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/03/src/hosts.tftpl)  

