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
- Изучил проект, посмотрел variables.tf. Файл variables.tf нужен для того, чтобы определить типы переменных и при необходимости, установить их значения по умолчанию.  

- Переименовал файл personal.auto.tfvars_example в personal.auto.tfvars, заполнил переменные. Поскольку файл personal.auto.tfvars находится в .gitignore, то можно не опасаться утечки данных. Передавать секретные переменные можно и другими способами. Например, в секретной переменной можно указать ключ sensitive = true, тогда при выполнении ```terraform plan/apply/output/console``` его значение не будет выведено в консоль.  
Также можно передавать секретные переменные в командной строке в ключе -var - ```terraform apply -var "token=***"```, использовать переменные окружения, предварительно их создав, например, командой export token=***, либо при выполнении ```terraform apply``` ссылаться на отдельный var файл вне рабочей директории проекта - ```terraform apply -var-file=~/.secret/private.tfvars```.  

- Создал короткий ssh ключ используя ```ssh-keygen -t ed25519```, записал его pub часть в переменную vms_ssh_root_key.  

- Инициализировал проект, выполнил код. Нашел ошибки в блоке resource "yandex_compute_instance" "platform" {.  

Ошибки были следующие:  

1. В строке platform_id = "standart-v4" должно быть слово standard  
2. Версия v4 неправильная. Согласно документации Yandex.Cloud (https://cloud.yandex.ru/docs/compute/concepts/vm-platforms) платформы могут быть только v1, v2 и v3.  
3. В строке cores = 1 указано неправильное количество ядер процессора. Согласно документации Yandex.Cloud (https://cloud.yandex.ru/docs/compute/concepts/performance-levels) минимальное количество виртуальных ядер процессора для всех платформ равно двум.  

После исправления ошибок удалось запустить код и создать виртуальную машину.  

Исправленный блок ресурса выглядит следующим образом:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/1_1.png)  

- Параметр ```preemptible = true``` применяется в том случае, если нужно сделать виртуальную машину прерываемой, то есть возможность остановки ВМ в любой момент. Применятся если с момента запуска машины прошло 24 часа либо возникает нехватка ресурсов для запуска ВМ. Прерываемые ВМ не обеспечивают отказоустойчивость.  

Параметр ```core_fraction=5``` указывает базовую производительность ядра в процентах. Указывается для экономии ресурсов.  

Виртуальная машина успешно создана:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/1_2.png)  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/1_3.png)  

Подключение по протоколу SSH работает:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/1_4.png)  

### Задание 2  
Изучите файлы проекта.  
Замените все хардкод-значения для ресурсов yandex_compute_image и yandex_compute_instance на отдельные переменные. К названиям переменных ВМ добавьте в начало префикс vm_web_ . Пример: vm_web_name.    
Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их default прежними значениями из main.tf.    
Проверьте terraform plan. Изменений быть не должно.    

#### Ответ:  
- Изучил файлы проекта. Проект разбит на отдельные файлы, описывающие ядро проекта, сетевую часть, описание общих переменных, блок провайдера, блок вывода информации.  
- Заменил хардкод-значения для ресурсов yandex_compute_image и yandex_compute_instance с добавлением префикса vm_web_:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/2_1.png)  
- Объявил переменные в файле variables.tf:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/2_2.png)  
- Выполнил ```terraform plan```, появилось сообщение о том, что terraform не нашел отличий от действующей инфраструктуры:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/2_3.png)  

### Задание 3  
Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.  
Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: "netology-develop-platform-db" , cores = 2, memory = 2, core_fraction = 20. Объявите её переменные с префиксом vm_db_ в том же файле ('vms_platform.tf').  
Примените изменения.  

#### Ответ:  
- Создал в корне проекта файл 'vms_platform.tf'. Перенес в него все переменные первой ВМ:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/3_1.png)  
- В блоке ресурса создал вторую ВМ с указанными параметрами и объявил её переменные с префиксом vm_db_ в файле vms_platform.tf:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/3_3.png)
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/3_4.png)  
- Применяю конфигурацию, вносится изменение в текущую инфраструктуру, создается еще одна виртуальная машина:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/3_5.png)  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/3_6.png)  


### Задание 4  
Объявите в файле outputs.tf output типа map, содержащий { instance_name = external_ip } для каждой из ВМ.  
Примените изменения.  
В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.  

#### Ответ:  
- Объявил в outputs.tf output типа map, получился следующий output:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/4_1.png)  
- Применил изменения, ```terraform output``` показал следующее:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/4_2.png)  


### Задание 5  
В файле locals.tf опишите в одном local-блоке имя каждой ВМ, используйте интерполяцию ${..} с несколькими переменными по примеру из лекции.  
Замените переменные с именами ВМ из файла variables.tf на созданные вами local-переменные.  
Примените изменения.  

#### Ответ:  
- В файле locals.tf применил интерполяцию, в одном блоке описал имена ВМ:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/5_1.png)  
- Закомментировал старые variables с именами, в main сослался на созданный local:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/5_2.png)  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/5_3.png)  
- Применил изменения  


### Задание 6  
Вместо использования трёх переменных ".._cores",".._memory",".._core_fraction" в блоке resources {...}, объедините их в переменные типа map с именами "vm_web_resources" и "vm_db_resources". В качестве продвинутой практики попробуйте создать одну map-переменную vms_resources и уже внутри неё конфиги обеих ВМ — вложенный map.    
Также поступите с блоком metadata {serial-port-enable, ssh-keys}, эта переменная должна быть общая для всех ваших ВМ.    
Найдите и удалите все более не используемые переменные проекта.    
Проверьте terraform plan. Изменений быть не должно.    

#### Ответ:  
- Описываю переменные ".._cores",".._memory",".._core_fraction" в vms_platform.tf:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/6_1.png)  
- В main.tf в блоке resources применяю описанные выше переменные:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/6_2.png)  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/6_3.png)  
- Для блока metadata описываю переменные:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/6_4.png)
В main.tf в блоке resources применяю описанные выше переменные:
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/6_5.png)
- Нашел и удалил неиспользуемые переменные.  
- Команда ```terraform plan``` изменение не выявила:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/6_6.png)  


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
- Поскольку нумерация идем со значения 0, то второй элемент можно отобразить командой ```local.test_list[1]```:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/7_1.png)  
- Длину списка test_list можно узнать командой ```length(["develop", "staging", "production"])```. Длина списка равна 3:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/7_2.png)  
- Отобразить значение ключа admin из map test_map можно командой ```local.test_map["admin"]```:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/7_3.png)  
- Для выполнения этого пункта я написал в output такое выражение:  
output "admin_server_info" { value = "${local.test_map.admin} is admin for  
${local.test_list[length(local.test_list)-1]} server based on OS  
${local.servers[local.test_list[length(local.test_list)-1]]["image"]} with  
${local.servers[local.test_list[length(local.test_list)-1]]["cpu"]} vcpu,  
${local.servers[local.test_list[length(local.test_list)-1]]["ram"]} ram, and  
${local.servers.production["disks"][0]}, ${local.servers.production["disks"][1]},  
${local.servers.production["disks"][2]},  
${local.servers.production["disks"][3]} virtual disks." }  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/7_4.png)  
Команда ```terraform output``` выводит нужный текст:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/02/img/7_5.png)  
