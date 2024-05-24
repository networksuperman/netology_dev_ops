# Домашнее задание к занятию 13.1 «Хранение в K8s. Часть 1»  

### Цель задания

В тестовой среде Kubernetes нужно обеспечить обмен файлами между контейнерам пода и доступ к логам ноды.

------

### Задание 1 

**Что нужно сделать**

Создать Deployment приложения, состоящего из двух контейнеров и обменивающихся данными.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Сделать так, чтобы busybox писал каждые пять секунд в некий файл в общей директории.
3. Обеспечить возможность чтения файла контейнером multitool.
4. Продемонстрировать, что multitool может читать файл, который периодоически обновляется.
5. Предоставить манифесты Deployment в решении, а также скриншоты или вывод команды из п. 4.

------

### Решение задания 1.

```
kubectl create ns netology

kubectl config set-context --current --namespace=netology
```
```
apiVersion: apps/v1
kind: Deployment
metadata:
  name: deployment1
  labels:
    app: dep1
spec:
  replicas: 1
  selector:
    matchLabels:
      app: dep1
  template:
    metadata:
      labels:
        app: dep1
    spec:
      containers:
      - name: busybox
        image: busybox
        command: ['sh', '-c', 'while true; do echo busybox message! >> /output/output.txt; sleep 5; done']
        volumeMounts:
        - name: dep1-volume
          mountPath: /output
      - name: multitool
        image: wbitt/network-multitool:latest
        ports:
        - containerPort: 80
        env:
        - name: HTTP_PORT
          value: "80"
        volumeMounts:
        - name: dep1-volume
          mountPath: /input
      volumes:
      - name: dep1-volume
        emptyDir: {}
```
sysadmin@sysadmin:~/1.6$ kubectl apply -f deployment1.yaml 
deployment.apps/deployment1 created
```
```
sysadmin@sysadmin:~/1.6$ kubectl get deployments,pods
NAME                          READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/deployment1   1/1     1            1           33s

NAME                               READY   STATUS    RESTARTS   AGE
pod/deployment1-5f4d76797f-rh9cd   2/2     Running   0          33s
```
```
sysadmin@sysadmin:~/1.6$ kubectl exec pod/deployment1-5f4d76797f-rh9cd -c busybox -- tail -f /output/output.txt
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
```
```
sysadmin@sysadmin:~/1.6$ kubectl exec pod/deployment1-5f4d76797f-rh9cd -c multitool -- cat /input/output.txt
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
busybox message!
```
![](./images/kube-stor-1.png)

[./configs/deployment1.yaml](deployment1.yaml)
