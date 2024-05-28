# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
[Deployment](,/configs/multitool.yaml)

```
nano multitool.yaml

apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: multi
  name: multitool
spec:
  replicas: 1
  selector:
    matchLabels:
      app: multi
  template:
    metadata:
      labels:
        app: multi
    spec:
      containers:          
      - name: multitool
        image: wbitt/network-multitool  
        volumeMounts:
        - name: my-volume
          mountPath: /multitool
      - name: busybox
        image: busybox
        command: ['sh', '-c', 'while true; do echo Write! >> /output/file.txt; sleep 10; done']
        volumeMounts:
        - name: my-volume
          mountPath: /output
      volumes:
      - name: my-volume
        persistentVolumeClaim:
          claimName: pvc
```
```
sysadmin@sysadmin:~/1.7$ kubectl apply -f multitool.yaml
deployment.apps/multitool created
sysadmin@sysadmin:~/1.7$ kubectl get pods
NAME                         READY   STATUS    RESTARTS   AGE
multitool-66c9d995bd-5rn5x   0/2     Pending   0          11s
```
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
[PV](./configs/pv.yaml) и [PVC](.configs/pvc.yaml)  
```
nano pv.yaml

apiVersion: v1
kind: PersistentVolume
metadata:
  name: pv
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  capacity:
    storage: 2Gi
  hostPath:
    path: /srv/nfs
  persistentVolumeReclaimPolicy: Delete   
```
```
nano pvc.yaml

apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: pvc
spec:
  storageClassName: ""
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 1Gi
```
```
sysadmin@sysadmin:~/1.7$ kubectl apply -f pvc.yaml
persistentvolumeclaim/pvc created

sysadmin@sysadmin:~/1.7$ kubectl get pvc
NAME   STATUS    VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
pvc    Pending                                                     <unset>                 8s
```
После создания `PV` запустился `Pod` и `PVC`  
```
sysadmin@sysadmin:~/1.7$ kubectl apply -f pv.yaml
persistentvolume/pv created
sysadmin@sysadmin:~/1.7$ kubectl get pod
NAME                         READY   STATUS    RESTARTS   AGE
multitool-66c9d995bd-5rn5x   2/2     Running   0          6m29s
sysadmin@sysadmin:~/1.7$ kubectl get pvc
NAME   STATUS   VOLUME   CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
pvc    Bound    pv       2Gi        RWO                           <unset>                 101s
sysadmin@sysadmin:~/1.7$ kubectl get pv
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM         STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pv     2Gi        RWO            Delete           Bound    default/pvc                  <unset>                          45s
```
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории.
```
sysadmin@sysadmin:~/1.7$ kubectl exec -c busybox multitool-66c9d995bd-5rn5x -- ls -la
total 52
drwxr-xr-x    1 root     root          4096 May 28 09:43 .
drwxr-xr-x    1 root     root          4096 May 28 09:43 ..
drwxr-xr-x    2 root     root         12288 May 18  2023 bin
drwxr-xr-x    5 root     root           360 May 28 09:43 dev
drwxr-xr-x    1 root     root          4096 May 28 09:43 etc
drwxr-xr-x    2 nobody   nobody        4096 May 18  2023 home
drwxr-xr-x    2 root     root          4096 May 18  2023 lib
lrwxrwxrwx    1 root     root             3 May 18  2023 lib64 -> lib
drwxr-xr-x    2 root     root          4096 May 28 09:43 output
dr-xr-xr-x  212 root     root             0 May 28 09:43 proc
drwx------    2 root     root          4096 May 18  2023 root
dr-xr-xr-x   13 root     root             0 May 28 09:43 sys
drwxrwxrwt    2 root     root          4096 May 18  2023 tmp
drwxr-xr-x    4 root     root          4096 May 18  2023 usr
drwxr-xr-x    1 root     root          4096 May 28 09:43 var

sysadmin@sysadmin:~/1.7$ kubectl exec -c busybox multitool-66c9d995bd-5rn5x -- ls -la /output
total 12
drwxr-xr-x    2 root     root          4096 May 28 09:43 .
drwxr-xr-x    1 root     root          4096 May 28 09:43 ..
-rw-r--r--    1 root     root            91 May 28 09:45 file.txt

sysadmin@sysadmin:~/1.7$ kubectl exec -c busybox multitool-66c9d995bd-5rn5x -- cat /output/file.txt
Write!
Write!
Write!
Write!
Write!
Write!
Write!
Write!
Write!
Write!

sysadmin@sysadmin:~/1.7$ kubectl exec -c multitool multitool-66c9d995bd-5rn5x -- ls -la
total 84
drwxr-xr-x    1 root     root          4096 May 28 09:43 .
drwxr-xr-x    1 root     root          4096 May 28 09:43 ..
drwxr-xr-x    1 root     root          4096 Sep 14  2023 bin
drwx------    2 root     root          4096 Sep 14  2023 certs
drwxr-xr-x    5 root     root           360 May 28 09:43 dev
drwxr-xr-x    1 root     root          4096 Sep 14  2023 docker
drwxr-xr-x    1 root     root          4096 May 28 09:43 etc
drwxr-xr-x    2 root     root          4096 Aug  7  2023 home
drwxr-xr-x    1 root     root          4096 Sep 14  2023 lib
drwxr-xr-x    5 root     root          4096 Aug  7  2023 media
drwxr-xr-x    2 root     root          4096 Aug  7  2023 mnt
drwxr-xr-x    2 root     root          4096 May 28 09:43 multitool
drwxr-xr-x    2 root     root          4096 Aug  7  2023 opt
dr-xr-xr-x  211 root     root             0 May 28 09:43 proc
drwx------    2 root     root          4096 Aug  7  2023 root
drwxr-xr-x    1 root     root          4096 May 28 09:43 run
drwxr-xr-x    1 root     root          4096 Sep 14  2023 sbin
drwxr-xr-x    2 root     root          4096 Aug  7  2023 srv
dr-xr-xr-x   13 root     root             0 May 28 09:43 sys
drwxrwxrwt    2 root     root          4096 Aug  7  2023 tmp
drwxr-xr-x    1 root     root          4096 Aug  7  2023 usr
drwxr-xr-x    1 root     root          4096 Sep 14  2023 var

sysadmin@sysadmin:~/1.7$ kubectl exec -c multitool multitool-66c9d995bd-5rn5x -- cat /multitool/file.txt
Write!
Write!
Write!
Write!
Write!
Write!
Write!
Write!
```
4. Продемонстрировать, что файл сохранился на локальном диске ноды, а также что произойдёт с файлом после удаления пода и deployment. Пояснить, почему.  
На машине с `microk8s` и проверяю файл
```
sysadmin@sysadmin:~/1.7$ sudo -i
root@sysadmin:~# cd /srv/nfs
root@sysadmin:/srv/nfs# ls
file.txt
root@sysadmin:/srv/nfs# cat file.txt
Write!
Write!
Write!
Write!
Write!
Write!
Write!
Write!
```
А теперь удаляю `Deployment` вместе с `Pod` и проверяю тот же файл.  
```
sysadmin@sysadmin:~/1.7$ kubectl delete deployment multitool
deployment.apps "multitool" deleted

sysadmin@sysadmin:~/1.7$ kubectl get pod
No resources found in default namespace.

sysadmin@sysadmin:~/1.7$ kubectl get all
NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   12d

root@sysadmin:/srv/nfs# ls
file.txt
root@sysadmin:/srv/nfs# cat file.txt
Write!
Write!
Write!
Write!
Write!
```
Файл не удалился - `Volume` был размещен за пределами `Pod-a`, поэтому данные сохранились после удаления `Deployment-a` и `Pod-a`   
После удаления `PV` и `PVC` файл остался. И даже если указали `RaclaimPolicy: Delete` - файл остался, потому что `Delete` - это удаление ресурсов из внешних провайдеров (только в облачных Storage)  

------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.


