# Домашнее задание к занятию 12.4 «Сетевое взаимодействие в K8S. Часть 1»  

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к приложению, установленному в предыдущем ДЗ и состоящему из двух контейнеров, по разным портам в разные контейнеры как внутри кластера, так и снаружи.

### Задание 1. Создать Deployment и обеспечить доступ к контейнерам приложения по разным портам из другого Pod внутри кластера

1. Создать Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт.
2. Создать Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080.
3. Создать отдельный Pod с приложением multitool и убедиться с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры.
4. Продемонстрировать доступ с помощью `curl` по доменному имени сервиса.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Решение задания 1.
1. Создаем Deployment приложения, состоящего из двух контейнеров (nginx и multitool), с количеством реплик 3 шт. Подготовим следующее yaml-описание в файле [deployment-1.yaml](./configs/deployment-1.yaml):
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-1
  labels:
    app: deployment-1
spec:
  replicas: 3
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
          image: nginx
        - name: multitool
          image: wbitt/network-multitool
          env:
            - name: HTTP_PORT
              value: "8080"
            - name: HTTPS_PORT
              value: "11443"
```
* Убеждаемся, что в текущем кластере kubernetes нет лишних запущенных Pods, ReplicaSets, Deployments и Services:
```
sysadmin@sysadmin:~$  kubectl get all
NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   44h
```
* Далее запускаем развертывание Deployment (из двух контейнеров: nginx и multitool) из вышеописанного файла [deployment-1.yaml](./configs/deployment-1.yaml):
```
sysadmin@sysadmin:~$ kubectl create -f deployment-1.yaml
deployment.apps/deployment-1 created
sysadmin@sysadmin:~$ kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
deployment-1-859bcd76bd-6qf26   2/2     Running   0          7s
deployment-1-859bcd76bd-lw62p   2/2     Running   0          7s
deployment-1-859bcd76bd-wgr96   2/2     Running   0          7s
```
2. Создаем Service, который обеспечит доступ внутри кластера до контейнеров приложения из п.1 по порту 9001 — nginx 80, по 9002 — multitool 8080. Подготовим следующее yaml-описание в файле [service-1.yaml](./configs/service-1.yaml):
```
---
apiVersion: v1
kind: Service
metadata:
  name: service-1
spec:
  selector:
    app: deployment-1
  ports:
    - name: nginx-http
      port: 9001
      targetPort: 80
    - name: multitool-http
      port: 9002
      targetPort: 8080
```
* Запускаем развертывание сервиса и проверяем его состояние:
```
sysadmin@sysadmin:~$ kubectl create -f service-1.yaml
service/service-1 created
sysadmin@sysadmin:~$ kubectl get services
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP             45h
service-1    ClusterIP   10.152.183.147   <none>        9001/TCP,9002/TCP   9s
```
3. Создаем отдельный Pod с приложением multitool и убеждаемся с помощью `curl`, что из пода есть доступ до приложения из п.1 по разным портам в разные контейнеры. 
* Подготовим следующее yaml-описание в файле [pod-1.yaml](./configs/pod-1.yaml):
```
---
apiVersion: v1
kind: Pod
metadata:
  name: pod-1
  labels:
    app: pod-1
spec:
  containers:
    - name: multitool
      image: wbitt/network-multitool
      env:
        - name: HTTP_PORT
          value: "1080"
        - name: HTTPS_PORT
          value: "10443"
```
* Запускаем Pod:
```
sysadmin@sysadmin:~$ kubectl create -f pod-1.yaml
pod/pod-1 created
sysadmin@sysadmin:~$ kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
deployment-1-859bcd76bd-6qf26   2/2     Running   0          4m39s
deployment-1-859bcd76bd-lw62p   2/2     Running   0          4m39s
deployment-1-859bcd76bd-wgr96   2/2     Running   0          4m39s
pod-1                           1/1     Running   0          7s
```
* Проверяем с помощью `curl`, что из пода есть доступ до приложений из п.1.(по разным портам в разные контейнеры):
```
sysadmin@sysadmin:~$ kubectl get pods -o wide
NAME                            READY   STATUS    RESTARTS   AGE    IP            NODE       NOMINATED NODE   READINESS GATES
deployment-1-859bcd76bd-6qf26   2/2     Running   0          11m    10.1.12.136   sysadmin   <none>           <none>
deployment-1-859bcd76bd-lw62p   2/2     Running   0          11m    10.1.12.144   sysadmin   <none>           <none>
deployment-1-859bcd76bd-wgr96   2/2     Running   0          11m    10.1.12.146   sysadmin   <none>           <none>
pod-1                           1/1     Running   0          7m1s   10.1.12.137   sysadmin   <none>           <none>
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i 10.1.12.136:80  | grep Server
Server: nginx/1.25.5
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i 10.1.12.136:8080  | grep Server
Server: nginx/1.24.0
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i 10.1.12.144:80  | grep Server
Server: nginx/1.25.5
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i 10.1.12.144:8080  | grep Server
Server: nginx/1.24.0
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i 10.1.12.146:80  | grep Server
Server: nginx/1.25.5
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i 10.1.12.146:8080  | grep Server
Server: nginx/1.24.0
```
* Видим, что pod-1 имеет доступ к открытым портам других подов. Подтвердим результат скриншотом: 
![K8s_12.4.1](./images/K8s_12.4.1.PNG)
* Проверяем с помощью `curl`, что из пода есть доступ до приложений из п.1. через сервис (по портам 9001 и 9002):
```
sysadmin@sysadmin:~$ kubectl get services
NAME         TYPE        CLUSTER-IP       EXTERNAL-IP   PORT(S)             AGE
kubernetes   ClusterIP   10.152.183.1     <none>        443/TCP             45h
service-1    ClusterIP   10.152.183.147   <none>        9001/TCP,9002/TCP   12m
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i 10.152.183.147:9001 | grep Server
Server: nginx/1.25.5
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i 10.152.183.147:9002 | grep Server
Server: nginx/1.24.0
```
* Видим, что pod-1 имеет доступ к открытым портам сервиса. Подтвердим результат скриншотом: 
![K8s_12.4.2](./images/K8s_12.4.2.PNG)
4. Продемонстрируем доступ с помощью `curl` по доменному имени сервиса (и по короткому, и по полному):
```
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i service-1:9001 | grep Server
Server: nginx/1.25.5
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i service-1:9002 | grep Server
Server: nginx/1.24.0
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i service-1.default.svc.cluster.local:9001 | grep Server
Server: nginx/1.25.5
sysadmin@sysadmin:~$ kubectl exec pod-1 -- curl --silent -i service-1.default.svc.cluster.local:9002 | grep Server
Server: nginx/1.24.0
```
* Подтвердим результат скриншотом: 
![K8s_12.4.3](./images/K8s_12.4.3.PNG)
5. Все манифесты представлены в файлах: 
[deployment-1.yaml](./configs/deployment-1.yaml),
[service-1.yaml](./configs/service-1.yaml),
[pod-1.yaml](./configs/pod-1.yaml).
6. Удалим лишние ресурсы (service-1 и pod-1):
```
sysadmin@sysadmin:~$ kubectl delete -f service-1.yaml
service "service-1" deleted
sysadmin@sysadmin:~$ kubectl delete -f pod-1.yaml
pod "pod-1" deleted
sysadmin@sysadmin:~$ kubectl get pods
NAME                            READY   STATUS    RESTARTS   AGE
deployment-1-859bcd76bd-6qf26   2/2     Running   0          26m
deployment-1-859bcd76bd-lw62p   2/2     Running   0          26m
deployment-1-859bcd76bd-wgr96   2/2     Running   0          26m
sysadmin@sysadmin:~$ kubectl get services
NAME         TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   45h
```
------

### Задание 2. Создать Service и обеспечить доступ к приложениям снаружи кластера

1. Создать отдельный Service приложения из Задания 1 с возможностью доступа снаружи кластера к nginx, используя тип NodePort.
2. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
3. Предоставить манифест и Service в решении, а также скриншоты или вывод команды п.2.

------
