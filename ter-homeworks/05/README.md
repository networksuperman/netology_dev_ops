## Домашнее задание к занятию «Использование Terraform в команде»  

### Задание 1  
Возьмите код:  
из ДЗ к лекции 4,  
из демо к лекции 4.  
Проверьте код с помощью tflint и checkov. Вам не нужно инициализировать этот проект.  
Перечислите, какие типы ошибок обнаружены в проекте (без дублей).  

#### Ответ:  
С помощью docker контейнера tflint проверяю первый код и получаю результат:  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_1.png)  

С помощью checkov проверяю ошибки во втором коде:  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_2.png)  

Обнаружены следующие ошибки:  
Не был инициализирован проект, соответственно нет установленного Terraform провайдера, есть объявленные, но неиспользуемые переменные, в модуле test-vm присутствует ссылка на ветку main без указания конкретного коммита. Если ветка main изменится, то после выполнения кода может быть непредсказуемый результат.  


### Задание 2  
Возьмите ваш GitHub-репозиторий с выполненным ДЗ 4 в ветке 'terraform-04' и сделайте из него ветку 'terraform-05'.  
Повторите демонстрацию лекции: настройте YDB, S3 bucket, yandex service account, права доступа и мигрируйте state проекта в S3 с блокировками. Предоставьте скриншоты процесса в качестве ответа.  
Закоммитьте в ветку 'terraform-05' все изменения.  
Откройте в проекте terraform console, а в другом окне из этой же директории попробуйте запустить terraform apply.  
Пришлите ответ об ошибке доступа к state.  
Принудительно разблокируйте state. Пришлите команду и вывод.  

#### Ответ:  
Создал S3 bucket, yandex service account, назначил права доступа, YDB:  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_3.png)  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_4_1.png)  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_5_1.png)  

Мигрировал state проекта в S3:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_6.png)  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_7.png)  

Ответ об ошибке доступа к state:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_8.png)  

Принудительно разблокирую state:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_9_1.png)  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_9_2.png)  

### Задание 3  
Сделайте в GitHub из ветки 'terraform-05' новую ветку 'terraform-hotfix'.  
Проверье код с помощью tflint и checkov, исправьте все предупреждения и ошибки в 'terraform-hotfix', сделайте коммит.  
Откройте новый pull request 'terraform-hotfix' --> 'terraform-05'.  
Вставьте в комментарий PR результат анализа tflint и checkov, план изменений инфраструктуры из вывода команды terraform plan.  
Пришлите ссылку на PR для ревью. Вливать код в 'terraform-05' не нужно.  
#### Ответ:  
Проверил код с помощью tflint и checkov, исправил все предупреждения и ошибки в 'terraform-hotfix', сделал коммит:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_10.png)  

Ссылка на PR для ревью:  
[После tflint и checkov исправил ошибки](https://github.com/networksuperman/terraform04/pull/4)  


### Задание 4  
Напишите переменные с валидацией и протестируйте их, заполнив default верными и неверными значениями. Предоставьте скриншоты проверок из terraform console.  
type=string, description="ip-адрес" — проверка, что значение переменной содержит верный IP-адрес с помощью функций cidrhost() или regex(). Тесты: "192.168.0.1" и "1920.1680.0.1";  
type=list(string), description="список ip-адресов" — проверка, что все адреса верны. Тесты: ["192.168.0.1", "1.1.1.1", "127.0.0.1"] и ["192.168.0.1", "1.1.1.1", "1270.0.0.1"].  

#### Ответ:  
Написал переменные с валидацией:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_11.png)  

Если в адресах нет ошибок, то terraform console выведет пустой результат.  

Если в адресах есть ошибки, то terraform console выведет результат валидации:  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_12.png)  

Ссылка на код: 
https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/src/validation/variables_4.tf  


### Задание 5*
Напишите переменные с валидацией:
type=string, description="любая строка" — проверка, что строка не содержит символов верхнего регистра;
type=object — проверка, что одно из значений равно true, а второе false, т. е. не допускается false false и true true:

```
variable "in_the_end_there_can_be_only_one" {
    description="Who is better Connor or Duncan?"
    type = object({
        Dunkan = optional(bool)
        Connor = optional(bool)
    })

    default = {
        Dunkan = true
        Connor = false
    }

    validation {
        error_message = "There can be only one MacLeod"
        condition = <проверка>
    }
}
```
#### Ответ:  
Напишите переменные с валидацией:  
![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_13.png)  

Если в валидации нет ошибок, то terraform console выведет пустой результат.  

Если в строке будут символы верхнего регистра, то увидим ошибку в terraform console:  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_14.png)  

Если значение Dunkan и Connor будет true или false, то увидим ошибку в terraform console:  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/img/img_15.png)  

Ссылка на код: 
https://github.com/networksuperman/netology_dev_ops/blob/main/ter-homeworks/05/src/validation/variables_5.tf  
