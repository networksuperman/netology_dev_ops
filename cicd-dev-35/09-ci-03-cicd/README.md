# Домашнее задание к занятию 9 «Процессы CI/CD»

# Подготовка к выполнению

* Создаем  две VM в Yandex Cloud

![](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/img/1%20(1).png)  

* Пропишите в inventory playbook созданные хосты.

* [Project](https://github.com/networksuperman/netology_dev_ops/tree/main/cicd-dev-35/09-ci-03-cicd/infrastructure)

![](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/img/1%20(2).png)  

# SonarQube

![](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/img/1%20(3).png)  

* Проверьте sonar-scanner --version

```
sonar-scanner --version
INFO: Scanner configuration file: /home/panarin/tmp/sonar-scanner-4.8.0.2856-linux/conf/sonar-scanner.properties
INFO: Project root configuration file: NONE
INFO: SonarScanner 4.8.0.2856
INFO: Java 11.0.17 Eclipse Adoptium (64-bit)
INFO: Linux 5.15.0-76-generic amd64
```
* Результат из интерфейса

![](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/img/1%20(6).png)  

* [fail.py](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/fail.py)

* Успешный анализ

![](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/img/1%20(7).png)  

# Nexus

![](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/img/1%20(4).png)  

![](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/img/1%20(5).png) 

* [maven-metadata.xml](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/maven-metadata.xml)

# Maven

* [pom.xml](https://github.com/networksuperman/netology_dev_ops/blob/main/cicd-dev-35/09-ci-03-cicd/pom.xml)  

