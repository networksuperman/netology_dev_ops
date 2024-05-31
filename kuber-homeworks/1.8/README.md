# Домашнее задание к занятию «Конфигурация приложений»

### Цель задания

В тестовой среде Kubernetes необходимо создать конфигурацию и продемонстрировать работу приложения.

------

### Задание 1. Создать Deployment приложения и решить возникшую проблему с помощью ConfigMap. Добавить веб-страницу

1. Создать Deployment приложения, состоящего из контейнеров nginx и multitool.
2. Решить возникшую проблему с помощью ConfigMap.
3. Продемонстрировать, что pod стартовал и оба конейнера работают.
4. Сделать простую веб-страницу и подключить её к Nginx с помощью ConfigMap. Подключить Service и показать вывод curl или в браузере.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

------

### Решение задания 1.

1. Создаем Deployment приложения, состоящего из 2-х контейнеров.
Подготовим следующее yaml-описание в файле [deployment-1.yaml](./configs/deployment-1.yaml):
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-1
  labels:
    app: deployment-1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployment-1
  template:
    metadata:
      labels:
        app: deployment-1
    spec:
      containers:
        - name: nginx
          image: mirror.gcr.io/nginx
        - name: multitool
          image: mirror.gcr.io/wbitt/network-multitool
```
* Убеждаемся, что в текущем кластере kubernetes нет лишних запущенных Pods, ReplicaSets, Deployments и Services:
```
sysadmin@sysadmin:~/1.8$ kubectl get all
NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   15d
```
* Далее запускаем развертывание Deployment (из двух контейнеров: nginx и multitool) из вышеописанного файла [deployment-1.yaml](./configs/deployment-1.yaml):
```
sysadmin@sysadmin:~/1.8$ kubectl create -f deployment-1.yaml
deployment.apps/deployment-1 created
```
* Наблюдаем за развертыванием Deployment и сталкиваемся с ошибкой:
```
sysadmin@sysadmin:~/1.8$ kubectl get deployments.apps
NAME           READY   UP-TO-DATE   AVAILABLE   AGE
deployment-1   0/1     1            0           21s
sysadmin@sysadmin:~/1.8$ kubectl get pods
NAME                          READY   STATUS   RESTARTS      AGE
deployment-1-799f56b9-dttzq   1/2     Error    1 (13s ago)   27s
```
* Проверяем логи развертывания Deployment:
```
sysadmin@sysadmin:~/1.8$ kubectl logs --tail=10 --all-containers=true --prefix=true deployment-1-799f56b9-dttzq
[pod/deployment-1-799f56b9-dttzq/nginx] /docker-entrypoint.sh: Launching /docker-entrypoint.d/30-tune-worker-processes.sh
[pod/deployment-1-799f56b9-dttzq/nginx] /docker-entrypoint.sh: Configuration complete; ready for start up
[pod/deployment-1-799f56b9-dttzq/nginx] 2024/05/31 09:47:11 [notice] 1#1: using the "epoll" event method
[pod/deployment-1-799f56b9-dttzq/nginx] 2024/05/31 09:47:11 [notice] 1#1: nginx/1.27.0
[pod/deployment-1-799f56b9-dttzq/nginx] 2024/05/31 09:47:11 [notice] 1#1: built by gcc 12.2.0 (Debian 12.2.0-14) 
[pod/deployment-1-799f56b9-dttzq/nginx] 2024/05/31 09:47:11 [notice] 1#1: OS: Linux 5.15.0-105-generic
[pod/deployment-1-799f56b9-dttzq/nginx] 2024/05/31 09:47:11 [notice] 1#1: getrlimit(RLIMIT_NOFILE): 65536:65536
[pod/deployment-1-799f56b9-dttzq/nginx] 2024/05/31 09:47:11 [notice] 1#1: start worker processes
[pod/deployment-1-799f56b9-dttzq/nginx] 2024/05/31 09:47:11 [notice] 1#1: start worker process 29
[pod/deployment-1-799f56b9-dttzq/nginx] 2024/05/31 09:47:11 [notice] 1#1: start worker process 30
[pod/deployment-1-799f56b9-dttzq/multitool] 2024/05/31 09:50:26 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address in use)
[pod/deployment-1-799f56b9-dttzq/multitool] nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address in use)
[pod/deployment-1-799f56b9-dttzq/multitool] 2024/05/31 09:50:26 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address in use)
[pod/deployment-1-799f56b9-dttzq/multitool] nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address in use)
[pod/deployment-1-799f56b9-dttzq/multitool] 2024/05/31 09:50:26 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address in use)
[pod/deployment-1-799f56b9-dttzq/multitool] nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address in use)
[pod/deployment-1-799f56b9-dttzq/multitool] 2024/05/31 09:50:26 [emerg] 1#1: bind() to 0.0.0.0:80 failed (98: Address in use)
[pod/deployment-1-799f56b9-dttzq/multitool] nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address in use)
[pod/deployment-1-799f56b9-dttzq/multitool] 2024/05/31 09:50:26 [emerg] 1#1: still could not bind()
[pod/deployment-1-799f56b9-dttzq/multitool] nginx: [emerg] still could not bind()
```
* Делаем вывод об ошибке, в соответствии с которой контейнер multitool не может использовать порт 80 по умолчанию, поскольку он занят другим контейнером (nginx). На странице с [описанием](https://github.com/wbitt/Network-MultiTool) Multitool в такой ситуации рекомендуется использовать экстра аргументы с переменными окружения.
Остановим неработающий Deployment:
```
sysadmin@sysadmin:~/1.8$ kubectl delete -f deployment-1.yaml
deployment.apps "deployment-1" deleted
```
2. Решим возникшую проблему с помощью ConfigMap.
* Опишем yaml-файл [configmap-1.yaml](./configs/configmap-1.yaml):
```
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-1
data:
  http-port: "1180"
  https-port: "11443"
```
* Опишем новый yaml-файл [deployment-2.yaml](./TASK_13.3/deployment-2.yaml):
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-2
  labels:
    app: deployment-2
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployment-2
  template:
    metadata:
      labels:
        app: deployment-2
    spec:
      containers:
        - name: nginx
          image: mirror.gcr.io/nginx
        - name: multitool
          image: mirror.gcr.io/wbitt/network-multitool
          env:
            - name: HTTP_PORT
              valueFrom:
                configMapKeyRef:
                  name: configmap-1
                  key: http-port
            - name: HTTPS_PORT
              valueFrom:
                configMapKeyRef:
                  name: configmap-1
                  key: https-port
```
3. Продемонстрируем, что pod стартовал и оба контейнера работают:
```
sysadmin@sysadmin:~/1.8$ kubectl create -f configmap-1.yaml
configmap/configmap-1 created
sysadmin@sysadmin:~/1.8$ kubectl create -f deployment-2.yaml
deployment.apps/deployment-2 created
sysadmin@sysadmin:~/1.8$ kubectl get deployments,pods,configmaps
NAME                           READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/deployment-2   1/1     1            1           7s

NAME                                READY   STATUS    RESTARTS   AGE
pod/deployment-2-5c4bcfdbf9-kgbtr   2/2     Running   0          7s

NAME                         DATA   AGE
configmap/configmap-1        2      15s
configmap/kube-root-ca.crt   1      23d
```
* Подтвердим успешность развертывания скриншотом:
![K8s_13.3.1](./images/K8s_13.3.1.png)

4. Сделаем простую веб-страницу и подключим её к Nginx с помощью ConfigMap:
* Опишем yaml-файл [configmap-2.yaml](./TASK_13.3/configmap-2.yaml):
```
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: configmap-2
data:
  http-port: "1180"
  https-port: "11443"
  index.html: |
    <html>
    <head>
    <title>***TEST NGINX WITH ConfigMap***</title>
    </head>
    <body>
    <h1>***TEST NGINX***</h1>
    </br>
    <h1>TEST ConfigMap for Netology homework</h1>
    </body>
    </html>
```
