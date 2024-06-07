# Домашнее задание к занятию «Helm»

### Цель задания

В тестовой среде Kubernetes необходимо установить и обновить приложения с помощью Helm.

------

### Чеклист готовности к домашнему заданию

1. Установленное k8s-решение, например, MicroK8S.
2. Установленный локальный kubectl.
3. Установленный локальный Helm.
4. Редактор YAML-файлов с подключенным репозиторием GitHub.

------

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Инструкция](https://helm.sh/docs/intro/install/) по установке Helm. [Helm completion](https://helm.sh/docs/helm/helm_completion/).

------

### Задание 1. Подготовить Helm-чарт для приложения

1. Необходимо упаковать приложение в чарт для деплоя в разные окружения.
```
sysadmin@sysadmin:~$ helm version
version.BuildInfo{Version:"v3.15.1", GitCommit:"e211f2aa62992bd72586b395de50979e31231829", GitTreeState:"clean", GoVersion:"go1.22.3"}

sysadmin@sysadmin:~$ git clone https://github.com/aak74/kubernetes-for-beginners.git

sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ 

Создаем шаблон

sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ helm template 01-simple
---
# Source: hard/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: demo
  labels:
    app: demo
spec:
  ports:
    - port: 80
      name: http
  selector:
    app: demo
---
# Source: hard/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
  labels:
    app: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
        - name: hard
          image: "nginx:1.16.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          resources:
            limits:
              cpu: 200m
              memory: 256Mi
            requests:
              cpu: 100m
              memory: 128Mi
```
Меняем номер версии приложения
```
sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ cat 01-simple/Chart.yaml
apiVersion: v2
name: hard
description: A minimal chart for demo

type: application

version: 0.1.2
appVersion: "1.18.0"
```
2. Каждый компонент приложения деплоится отдельным deployment’ом или statefulset’ом.
3. В переменных чарта измените образ приложения для изменения версии.

------
### Задание 2. Запустить две версии в разных неймспейсах

1. Подготовив чарт, необходимо его проверить. Запуститe несколько копий приложения.
2. Одну версию в namespace=app1, вторую версию в том же неймспейсе, третью версию в namespace=app2.
3. Продемонстрируйте результат.

```
sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ helm template 01-simple
WARNING: Kubernetes configuration file is group-readable. This is insecure. Location: /home/sysadmin/.kube/config
WARNING: Kubernetes configuration file is world-readable. This is insecure. Location: /home/sysadmin/.kube/config
---
# Source: hard/templates/service.yaml
apiVersion: v1
kind: Service
metadata:
  name: demo
  labels:
    app: demo
spec:
  ports:
    - port: 80
      name: http
  selector:
    app: demo
---
# Source: hard/templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: demo
  labels:
    app: demo
spec:
  replicas: 1
  selector:
    matchLabels:
      app: demo
  template:
    metadata:
      labels:
        app: demo
    spec:
      containers:
        - name: hard
          image: "nginx:1.18.0"
          imagePullPolicy: IfNotPresent
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          resources:
            limits:
              cpu: 200m
              memory: 256Mi
            requests:
              cpu: 100m
              memory: 128Mi
```
Копируем конфиг
```
sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ microk8s kubectl config view --raw > ~/.kube/config  
```
Устанавливаем
```
sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ helm install demo1 01-simple
NAME: demo1
LAST DEPLOYED: Fri Jun  7 07:50:40 2024
NAMESPACE: default
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
Deployed version 1.18.0.

---------------------------------------------------------

sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ helm list
NAME    NAMESPACE       REVISION        UPDATED                                 STATUS          CHART           APP VERSION
demo1   default         1               2024-06-07 07:50:40.798791953 +0000 UTC deployed        hard-0.1.2      1.18.0     
```
Запустим несколько версий приложения
```
sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ helm upgrade demo1 --set replicaCount=3 01-simple
Release "demo1" has been upgraded. Happy Helming!
NAME: demo1
LAST DEPLOYED: Fri Jun  7 07:52:15 2024
NAMESPACE: default
STATUS: deployed
REVISION: 2
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
Deployed version 1.18.0.

---------------------------------------------------------

sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ kubectl get pod
NAME                  READY   STATUS    RESTARTS   AGE
demo-8965f6bd-gl8sw   1/1     Running   0          118s
demo-8965f6bd-pcnbx   1/1     Running   0          24s
demo-8965f6bd-pzwqs   1/1     Running   0          24s
```
Удалим helm demo1, затем создадим новый в namespace
```
sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ helm uninstall demo1
release "demo1" uninstalled

sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ helm install demo2 --namespace app1 --create-namespace --wait --set replicaCount=2 01-simple
NAME: demo2
LAST DEPLOYED: Fri Jun  7 07:53:27 2024
NAMESPACE: app1
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
Deployed version 1.18.0.

---------------------------------------------------------

sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ helm install demo2 --namespace app2 --create-namespace --wait --set replicaCount=1 01-simple
NAME: demo2
LAST DEPLOYED: Fri Jun  7 07:54:07 2024
NAMESPACE: app2
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
---------------------------------------------------------

Content of NOTES.txt appears after deploy.
Deployed version 1.18.0.

---------------------------------------------------------

sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ kubectl get pod -n app1
NAME                  READY   STATUS    RESTARTS   AGE
demo-8965f6bd-q59xb   1/1     Running   0          70s
demo-8965f6bd-vmprb   1/1     Running   0          70s

sysadmin@sysadmin:~/kubernetes-for-beginners/40-helm/01-templating/charts$ kubectl get pod -n app2
NAME                  READY   STATUS    RESTARTS   AGE
demo-8965f6bd-6c66m   1/1     Running   0          36s
```
