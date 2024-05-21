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
* Подготовим следующее yaml-описание в файле [deployment-2.yaml](./configs/deployment-2.yaml):
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
* Подготовим следующее yaml-описание для приложения _backend_ в файле [service-backend.yaml](./configs/service-backend.yaml):
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
* Запускаем развертывание созданных сервисов и убеждаемся в его успешности:
```
sysadmin@sysadmin:~/1.5$ kubectl create -f service-frontend.yaml
service/service-frontend created
sysadmin@sysadmin:~/1.5$ kubectl create -f service-backend.yaml
service/service-backend created
sysadmin@sysadmin:~/1.5$ kubectl get svc
NAME               TYPE        CLUSTER-IP      EXTERNAL-IP   PORT(S)    AGE
kubernetes         ClusterIP   10.152.183.1    <none>        443/TCP    5d20h
service-backend    ClusterIP   10.152.183.67   <none>        9002/TCP   6s
service-frontend   ClusterIP   10.152.183.46   <none>        9001/TCP   12s
```
4. Проверяем и убеждаемся, что приложения видят друг друга с помощью Service с использованием краткого и полного DNS-имени.
```
sysadmin@sysadmin:~/1.5$ kubectl exec -it services/service-frontend -- curl --silent -i service-backend:9002 | grep Server
Server: nginx/1.24.0
sysadmin@sysadmin:~/1.5$ kubectl exec -it services/service-frontend -- curl --silent -i service-backend.default.svc.cluster.local:9002 | grep Server
Server: nginx/1.24.0
sysadmin@sysadmin:~/1.5$ kubectl exec -it services/service-backend -- curl --silent -i service-frontend:9001 | grep Server
Server: nginx/1.25.5
sysadmin@sysadmin:~/1.5$ kubectl exec -it services/service-backend -- curl --silent -i service-frontend.default.svc.cluster.local:9001 | grep Server
Server: nginx/1.25.5
```
* Видим, что приложения имеют доступ друг к другу с помощью Service.
* Подтвердим результат скриншотом:

![K8s_12.5.1](./images/K8s_12.5.1.png)  

5. Все манифесты представлены в файлах: 
[deployment-1.yaml](./configs/deployment-1.yaml),
[deployment-2.yaml](./configs/deployment-2.yaml),
[service-frontend.yaml](./configs/service-frontend.yaml),
[service-backend.yaml](./configs/service-backend.yaml).

------
### Задание 2. Создать Ingress и обеспечить доступ к приложениям снаружи кластера

1. Включить Ingress-controller в MicroK8S.
2. Создать Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S так, чтобы при запросе только по адресу открывался _frontend_ а при добавлении /api - _backend_.
3. Продемонстрировать доступ с помощью браузера или `curl` с локального компьютера.
4. Предоставить манифесты и скриншоты или вывод команды п.2.

------

### Решение задания 2.

1. Включаем Ingress-controller в MicroK8S:
```
sysadmin@sysadmin:~/1.5$ microk8s enable ingress
Infer repository core for addon ingress
Enabling Ingress
ingressclass.networking.k8s.io/public created
ingressclass.networking.k8s.io/nginx created
namespace/ingress created
serviceaccount/nginx-ingress-microk8s-serviceaccount created
clusterrole.rbac.authorization.k8s.io/nginx-ingress-microk8s-clusterrole created
role.rbac.authorization.k8s.io/nginx-ingress-microk8s-role created
clusterrolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
rolebinding.rbac.authorization.k8s.io/nginx-ingress-microk8s created
configmap/nginx-load-balancer-microk8s-conf created
configmap/nginx-ingress-tcp-microk8s-conf created
configmap/nginx-ingress-udp-microk8s-conf created
daemonset.apps/nginx-ingress-microk8s-controller created
Ingress is enabled
```
2. Создаем Ingress, обеспечивающий доступ снаружи по IP-адресу кластера MicroK8S.
* Подготовим следующее yaml-описание для _Ingress_ в файле [ingress-1.yaml](./configs/ingress-1.yaml):
```
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-1
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: service-frontend
            port:
              number: 9001
      - path: /api
        pathType: Prefix
        backend:
          service:
            name: service-backend
            port:
              number: 9002
```
* Запускаем развертывание созданного _Ingress_ и убеждаемся в его успешности:
```
sysadmin@sysadmin:~/1.5$ kubectl create -f ingress-1.yaml
ingress.networking.k8s.io/ingress-1 created
sysadmin@sysadmin:~/1.5$ kubectl get ingress
NAME        CLASS    HOSTS   ADDRESS   PORTS   AGE
ingress-1   public   *                 80      8s
sysadmin@sysadmin:~/1.5$ kubectl describe ingress
Name:             ingress-1
Labels:           <none>
Namespace:        default
Address:          
Ingress Class:    public
Default backend:  <default>
Rules:
  Host        Path  Backends
  ----        ----  --------
  *           
              /      service-frontend:9001 (10.1.12.136:80,10.1.12.139:80,10.1.12.146:80)
              /api   service-backend:9002 (10.1.12.141:1180)
Annotations:  nginx.ingress.kubernetes.io/rewrite-target: /
Events:
  Type    Reason  Age   From                      Message
  ----    ------  ----  ----                      -------
  Normal  Sync    14s   nginx-ingress-controller  Scheduled for sync
```
3. Продемонстрируем доступ с помощью `curl` с локального компьютера:
* Определим внешний IP-адрес ноды:
```
sysadmin@sysadmin:~/1.5$ kubectl get nodes -o yaml | grep IPv4Addr
      projectcalico.org/IPv4Address: 192.168.6.196/21
```
* Проверим доступ с помощью `curl` с локального компьютера (только по адресу без добавления `/api`):
```
Выполнял в WARP терминале поэтому вывод такой, на скрине ниже покажу, что это другой ПК

curl --silent -i 192.168.6.196
HTTP/1.1 200 OK
Date: Tue, 21 May 2024 08:16:26 GMT
Content-Type: text/html
Content-Length: 615
Connection: keep-alive
Last-Modified: Tue, 16 Apr 2024 14:29:59 GMT
ETag: "661e8b67-267"
Accept-Ranges: bytes

<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
html { color-scheme: light dark; }
body { width: 35em; margin: 0 auto;
font-family: Tahoma, Verdana, Arial, sans-serif; }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
* Подтвердим результат скриншотом: 
![K8s_12.5.2](./images/K8s_12.5.2.png)
* Еще раз проверим доступ с помощью `curl` с локального компьютера (по адресу c добавлением `/api`):
```
curl --silent -i 192.168.6.196/api
HTTP/1.1 200 OK
Date: Tue, 21 May 2024 08:22:28 GMT
Content-Type: text/html
Content-Length: 155
Connection: keep-alive
Last-Modified: Tue, 21 May 2024 08:14:51 GMT
ETag: "664c57fb-9b"
Accept-Ranges: bytes

WBITT Network MultiTool (with NGINX) - deployment-backend-75899758b4-njkjf - 10.1.12.138 - HTTP: 1180 , HTTPS: 11443 . (Formerly praqma/network-multitool)
```
* Подтвердим результат скриншотом: 
![K8s_12.5.3](./images/K8s_12.5.3.png)
* Делаем вывод, что:
    + обращение выполняется к frontend-сервису при использовании адреса без `/api`,
    + обращение выполняется к backend-сервису при использовании адреса c `/api`.
4. Манифест представлен в файле: 
[ingress-1.yaml](./configs/ingress-1.yaml)
5. Удалим все развернутые ресурсы:
```
sysadmin@sysadmin:~/1.5$ kubectl delete -f ingress-1.yaml
ingress.networking.k8s.io "ingress-1" deleted
sysadmin@sysadmin:~/1.5$ kubectl delete -f service-backend.yaml
service "service-backend" deleted
sysadmin@sysadmin:~/1.5$ kubectl delete -f service-frontend.yaml
service "service-frontend" deleted
sysadmin@sysadmin:~/1.5$ kubectl delete -f deployment-2.yaml
deployment.apps "deployment-backend" deleted
sysadmin@sysadmin:~/1.5$ kubectl delete -f deployment-1.yaml
deployment.apps "deployment-frontend" deleted
sysadmin@sysadmin:~/1.5$ kubectl get all
NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   5d20h
```
