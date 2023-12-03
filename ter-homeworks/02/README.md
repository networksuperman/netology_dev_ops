## Домашнее задание к занятию «Основы Terraform. Yandex Cloud»  

### Задание 1  
Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.  
Переименуйте файл personal.auto.tfvars_example в personal.auto.tfvars. Заполните переменные: идентификаторы облака, токен доступа. Благодаря .gitignore этот файл не попадёт в публичный репозиторий. Вы можете выбрать иной способ безопасно передать секретные данные в terraform.  
Сгенерируйте или используйте свой текущий ssh-ключ. Запишите его открытую часть в переменную vms_ssh_root_key.  
Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, посимвольно. Ответьте, в чём заключается их суть.  
Ответьте, как в процессе обучения могут пригодиться параметры preemptible = true и core_fraction=5 в параметрах ВМ. Ответ в документации Yandex Cloud.  
В качестве решения приложите:  
скриншот ЛК Yandex Cloud с созданной ВМ;  
скриншот успешного подключения к консоли ВМ через ssh. К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: "ssh ubuntu@vm_ip_address"; Вы познакомитесь с тем как при создании ВМ кастомизировать пользователя в блоке metadata в следующей лекции.  
ответы на вопросы.  

#### Ответ:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/1_1.png)  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/1_2.png)  


### Задание 2  
Изучите файлы проекта.  
Замените все хардкод-значения для ресурсов yandex_compute_image и yandex_compute_instance на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс vm_web_ . Пример: vm_web_name.    
Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их default прежними значениями из main.tf.    
Проверьте terraform plan. Изменений быть не должно.    

#### Ответ:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/2_1.png)  


### Задание 3  
Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.  
Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: "netology-develop-platform-db" , cores = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом vm_db_ в том же файле ('vms_platform.tf').  
Примените изменения.  

#### Ответ:  
https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/src/vms_platform.tf  

### Задание 4  
Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.  
Примените изменения.  
В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.  

#### Ответ:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/4_1.png)  


### Задание 5  
В файле locals.tf опишите в одном local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.  
Замените переменные с именами ВМ из файла variables.tf на созданные вами local-переменные.  
Примените изменения.  

#### Ответ:  
https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/src/locals.tf  

### Задание 6  
Вместо использования трёх переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедините их в переменные типа map с именами "vm_web_resources" и "vm_db_resources". В качестве продвинутой практики попробуйте создать одну map-переменную vms_resources и уже внутри неё конфиги обеих ВМ — вложенный map.    
Также поступите с блоком metadata {serial-port-enable, ssh-keys}, эта переменная должна быть общая для всех ваших ВМ.    
Найдите и удалите все более не используемые переменные проекта.    
Проверьте terraform plan. Изменений быть не должно.    

#### Ответ:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/6_1.png)  


Дополнительное задание (со звёздочкой*)  

### Задание 7*  
Изучите содержимое файла console.tf. Откройте terraform console, выполните следующие задания:  
Напишите, какой командой можно отобразить второй элемент списка test_list.  
Найдите длину списка test_list с помощью функции length(<имя переменной>).  
Напишите, какой командой можно отобразить значение ключа admin из map test_map.  
Напишите interpolation-выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.  
Примечание: если не догадаетесь как вычленить слово "admin", погуглите: "terraform get keys of map"  
В качестве решения предоставьте необходимые команды и их вывод.  

#### Ответ:  
- Напишите, какой командой можно отобразить второй элемент списка test_list?  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/7_1.png)  

- Найдите длину списка test_list с помощью функции length(<имя переменной>).  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/7_2.png)  

- Напишите, какой командой можно отобразить значение ключа admin из map test_map ?  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/7_3.png)  

- Напишите interpolation выражение, результатом которого будет: "John is admin for production server based on OS ubuntu-20-04 with X vcpu, Y ram and Z virtual disks", используйте данные из переменных test_list, test_map, servers и функцию length() для подстановки значений.
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/7_4.png)  


