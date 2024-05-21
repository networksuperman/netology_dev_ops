# Домашнее задание к занятию «Сетевое взаимодействие в K8S. Часть 2»

### Цель задания

В тестовой среде Kubernetes необходимо обеспечить доступ к двум приложениям снаружи кластера по разным путям.

------

### Задание 1. Создать Deployment приложений backend и frontend

1. Создать Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
2. Создать Deployment приложения _backend_ из образа multitool. 
3. Добавить Service, которые обеспечат доступ к обоим приложениям внутри кластера. 
4. Продемонстрировать, что приложения видят друг друга с помощью Service.
5. Предоставить манифесты Deployment и Service в решении, а также скриншоты или вывод команды п.4.

------

### Решение задания 1.
1. Создаем Deployment приложения _frontend_ из образа nginx с количеством реплик 3 шт.
* Подготовим следующее yaml-описание в файле [deployment-1.yaml](./configs/deployment-1.yaml):
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-frontend
  labels:
    app: deployment-frontend
spec:
  replicas: 3
  selector:
    matchLabels:
      app: deployment-frontend
  template:
    metadata:
      labels:
        app: deployment-frontend
    spec:
      containers:
        - name: nginx
          image: nginx
```
* Запускаем развертывание Deployment приложения _frontend_ и убеждаемся в его успешности:
```
sysadmin@sysadmin:~/1.5$ kubectl create -f deployment-1.yaml
deployment.apps/deployment-frontend created
sysadmin@sysadmin:~/1.5$ kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
deployment-frontend-c56c589bc-bv57z   1/1     Running   0          10s
deployment-frontend-c56c589bc-dvs6d   1/1     Running   0          10s
deployment-frontend-c56c589bc-wdtxv   1/1     Running   0          10s
sysadmin@sysadmin:~/1.5$ kubectl get deployments.apps
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment-frontend   3/3     3            3           16s
```
2. Создаем Deployment приложения _backend_ из образа multitool. 
* Подготовим следующее yaml-описание в файле [deployment-2.yaml](./TASK_12.5/deployment-2.yaml):
```
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment-backend
  labels:
    app: deployment-backend
spec:
  replicas: 1
  selector:
    matchLabels:
      app: deployment-backend
  template:
    metadata:
      labels:
        app: deployment-backend
    spec:
      containers:
        - name: multitool
          image: wbitt/network-multitool
          env:
            - name: HTTP_PORT
              value: "1180"
            - name: HTTPS_PORT
              value: "11443"
```
* Запускаем развертывание Deployment приложения _backend_ и убеждаемся в его успешности:
```
sysadmin@sysadmin:~/1.5$ kubectl create -f deployment-2.yaml
deployment.apps/deployment-backend created
sysadmin@sysadmin:~/1.5$ kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
deployment-backend-75899758b4-ttpv5   1/1     Running   0          10s
deployment-frontend-c56c589bc-bv57z   1/1     Running   0          2m10s
deployment-frontend-c56c589bc-dvs6d   1/1     Running   0          2m10s
deployment-frontend-c56c589bc-wdtxv   1/1     Running   0          2m10s
sysadmin@sysadmin:~/1.5$ kubectl get deployments.apps
NAME                  READY   UP-TO-DATE   AVAILABLE   AGE
deployment-backend    1/1     1            1           19s
deployment-frontend   3/3     3            3           2m19s
```
3. Создаем Service, которые обеспечат доступ к обоим приложениям внутри кластера.
* Подготовим следующее yaml-описание для приложения _frontend_ в файле [service-frontend.yaml](./configs/service-frontend.yaml):
```
---
apiVersion: v1
kind: Service
metadata:
  name: service-frontend
spec:
  selector:
    app: deployment-frontend
  ports:
    - name: nginx-http
      port: 9001
      targetPort: 80
```
* Подготовим следующее yaml-описание для приложения _backend_ в файле [service-backend.yaml](./TASK_12.5/service-backend.yaml):
```
---
apiVersion: v1
kind: Service
metadata:
  name: service-backend
spec:
  selector:
    app: deployment-backend
  ports:
    - name: multitool-http
      port: 9002
      targetPort: 1180
```
