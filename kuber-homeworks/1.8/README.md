# Домашнее задание к занятию «Конфигурация приложений»

### Цель задания

В тестовой среде Kubernetes необходимо создать конфигурацию и продемонстрировать работу приложения.

------

### Чеклист готовности к домашнему заданию

1. Установленное K8s-решение (например, MicroK8s).
2. Установленный локальный kubectl.
3. Редактор YAML-файлов с подключённым GitHub-репозиторием.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Описание](https://kubernetes.io/docs/concepts/configuration/secret/) Secret.
2. [Описание](https://kubernetes.io/docs/concepts/configuration/configmap/) ConfigMap.
3. [Описание](https://github.com/wbitt/Network-MultiTool) Multitool.

------

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Решить возникшую проблему с помощью ConfigMap.
3. Продемонстрировать, что pod стартовал и оба конейнера работают.
4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

## Решение:

[deploy.yml](./configs/deploy.yml)
```
sysadmin@sysadmin:~/1.8$ kubectl apply -f deploy.yml 
configmap/my-configmap created
deployment.apps/deployment-kuber created
service/svc created

sysadmin@sysadmin:~/1.8$ kubectl get po
NAME                                READY   STATUS    RESTARTS   AGE
deployment-kuber-798989944b-s64q8   2/2     Running   0          47s

sysadmin@sysadmin:~/1.8$ kubectl get svc
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)                       AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP                       16d
svc          NodePort    10.152.183.209   <none>        80:30080/TCP,1180:30180/TCP   86s

sysadmin@sysadmin:~/1.8$ curl 10.152.183.209
<html>
<h1>Welcome</h1>
</br>
<h1>My test page for nginx!! </h1>
</html
```
------

### Задание 2. Создать приложение с вашей веб-страницей, доступной по HTTPS 

1. Создать Deployment приложения, состоящего из Nginx.
2. Создать собственную веб-страницу и подключить её как ConfigMap к приложению.
3. Выпустить самоподписной сертификат SSL. Создать Secret для использования сертификата.
4. Создать Ingress и необходимый Service, подключить к нему SSL в вид. Продемонстировать доступ к приложению по HTTPS. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

## Решение:

[[deploy2.yml](./configs/deploy2.yml)
```
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout tls.key -out tls.crt -subj "/CN=localhost"

cat tls.crt | base64
cat tls.key | base64

sysadmin@sysadmin:~/1.8$ kubectl apply -f deploy2.yml 
configmap/index-html-configmap created
secret/test-tls created
deployment.apps/nginx-deployment created
service/nginx-service created
ingress.networking.k8s.io/minimal-ingress created

curl -k https://localhost
<html>
<h1>Welcome</h1>
</br>
<h1>Hi! This is a configmap Index file </h1>
</html
```


