# Домашнее задание к занятию «Хранение в K8s. Часть 2»

### Цель задания

В тестовой среде Kubernetes нужно создать PV и продемострировать запись и хранение файлов.

------

### Задание 1

**Что нужно сделать**

Создать Deployment приложения, использующего локальный PV, созданный вручную.

1. Создать Deployment приложения, состоящего из контейнеров busybox и multitool.
2. Создать PV и PVC для подключения папки на локальной ноде, которая будет использована в поде.
3. Продемонстрировать, что multitool может читать файл, в который busybox пишет каждые пять секунд в общей директории. 
4. Удалить Deployment и PVC. Продемонстрировать, что после этого произошло с PV. Пояснить, почему.
5. Продемонстрировать, что файл сохранился на локальном диске ноды. Удалить PV.  Продемонстрировать что произошло с файлом после удаления PV. Пояснить, почему.
5. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Решение:  

1. Создаем deployment [deployment.yaml](./configs/deployment.yaml) и развертываем `kubectl apply -f deployment.yaml`
```
sysadmin@sysadmin:~$ kubectl apply -f deployment.yaml
deployment.apps/netology-kube created
```
Проверяем и видим что поды не стартуют - ждут том
```
sysadmin@sysadmin:~$ kubectl get all
NAME                                 READY   STATUS    RESTARTS   AGE
pod/netology-kube-7778678889-6nfd6   0/2     Pending   0          33s

NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   13d

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/netology-kube   0/1     1            0           33s

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/netology-kube-7778678889   1         1         0       33s
```
2. Создаем persistentvolume [persistentvolume.yaml](./configs/persistentvolume.yaml) и развертываем `kubectl apply -f persistentvolume.yaml`
   
Создаем persistentvolumeclaim [persistentvolumeclaim.yaml](./configs/persistentvolumeclaim.yaml) и развертываем `kubectl apply -f persistentvolumeclaim.yaml`
```
sysadmin@sysadmin:~$ kubectl apply -f persistentvolume.yaml
persistentvolume/pv1 created

sysadmin@sysadmin:~$ kubectl apply -f persistentvolumeclaim.yaml
persistentvolumeclaim/pvc-vol created
```
Проверяем: 
```
sysadmin@sysadmin:~$ kubectl get persistentvolume
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS   CLAIM             STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pv1    100Mi      RWO            Retain           Bound    default/pvc-vol                  <unset>                          41s
sysadmin@sysadmin:~$ kubectl get all
NAME                                 READY   STATUS    RESTARTS   AGE
pod/netology-kube-7778678889-6nfd6   2/2     Running   0          4m45s

NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   13d

NAME                            READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/netology-kube   1/1     1            1           4m45s

NAME                                       DESIRED   CURRENT   READY   AGE
replicaset.apps/netology-kube-7778678889   1         1         1       4m45s
```
Видим что PVC связался с PV и поды запустились

3. Проверяем что поды пишут и читают
```
sysadmin@sysadmin:~$ kubectl logs --tail=10  netology-kube-7778678889-6nfd6 multitool 
Tue May 28 11:47:03 UTC 2024
Tue May 28 11:47:08 UTC 2024
Tue May 28 11:47:13 UTC 2024
Tue May 28 11:47:18 UTC 2024
Tue May 28 11:47:23 UTC 2024
Tue May 28 11:47:28 UTC 2024
Tue May 28 11:47:33 UTC 2024
Tue May 28 11:47:38 UTC 2024
Tue May 28 11:47:43 UTC 2024
Tue May 28 11:47:48 UTC 2024
```
4. После удаления Deploymentи PVC PV меняется с Bound на Released(запрос был удален, но связанный с ним ресурс хранения еще не восстановлен кластером) так как мы устанавливали директиву ` persistentVolumeReclaimPolicy: Retain`.
```
sysadmin@sysadmin:~$ kubectl delete deployments.apps netology-kube 
deployment.apps "netology-kube" deleted

sysadmin@sysadmin:~$ kubectl delete persistentvolumeclaims pvc-vol 
persistentvolumeclaim "pvc-vol" deleted

sysadmin@sysadmin:~$ kubectl get all
NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   13d

sysadmin@sysadmin:~$ kubectl get persistentvolumeclaims 
No resources found in default namespace.

sysadmin@sysadmin:~$ kubectl get persistentvolume
NAME   CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM             STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
pv1    100Mi      RWO            Retain           Released   default/pvc-vol                  <unset>                          4m58s
```
5. Проверяем наличие файла на ноде
```
sysadmin@sysadmin:~$ tail /tmp/pv1/output.txt 
Tue May 28 11:48:23 UTC 2024
Tue May 28 11:48:28 UTC 2024
Tue May 28 11:48:33 UTC 2024
Tue May 28 11:48:38 UTC 2024
Tue May 28 11:48:43 UTC 2024
Tue May 28 11:48:48 UTC 2024
Tue May 28 11:48:53 UTC 2024
Tue May 28 11:48:58 UTC 2024
Tue May 28 11:49:03 UTC 2024
Tue May 28 11:49:08 UTC 2024
```
------

### Задание 2

**Что нужно сделать**

Создать Deployment приложения, которое может хранить файлы на NFS с динамическим созданием PV.

1. Включить и настроить NFS-сервер на MicroK8S.
2. Создать Deployment приложения состоящего из multitool, и подключить к нему PV, созданный автоматически на сервере NFS.
3. Продемонстрировать возможность чтения и записи файла изнутри пода. 
4. Предоставить манифесты, а также скриншоты или вывод необходимых команд.

### Решение:  

1. Поднимаем NFS и проверяем
```
sudo apt install -y nfs-common
microk8s enable community
microk8s enable nfs

sysadmin@sysadmin:~$ kubectl get sc
NAME   PROVISIONER                            RECLAIMPOLICY   VOLUMEBINDINGMODE   ALLOWVOLUMEEXPANSION   AGE
nfs    cluster.local/nfs-server-provisioner   Delete          Immediate           true                   11s
```
2. Создаем deployment_nfs [deployment_nfs.yaml](./configs/deployment_nfs.yaml) и развертываем `kubectl apply -f deployment_nfs.yaml`
Создаем persistentvolumeclaim_nfs [persistentvolumeclaim_nfs.yaml](./configs/persistentvolumeclaim_nfs.yaml) и развертываем `kubectl apply -f persistentvolumeclaim_nfs.yaml`
```
sysadmin@sysadmin:~$ kubectl apply -f deployment_nfs.yaml
deployment.apps/netology-kube-nfs created

sysadmin@sysadmin:~$ kubectl apply -f persistentvolumeclaim_nfs.yaml
persistentvolumeclaim/pvc-nfs created
```
Проверяем:
```
sysadmin@sysadmin:~$ kubectl get all
NAME                                    READY   STATUS    RESTARTS   AGE
pod/netology-kube-nfs-77d67bdc4-fmz7k   1/1     Running   0          35s

NAME                 TYPE        CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
service/kubernetes   ClusterIP   10.152.183.1   <none>        443/TCP   13d

NAME                                READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/netology-kube-nfs   1/1     1            1           35s

NAME                                          DESIRED   CURRENT   READY   AGE
replicaset.apps/netology-kube-nfs-77d67bdc4   1         1         1       35s

sysadmin@sysadmin:~$ kubectl get pvc
NAME      STATUS   VOLUME                                     CAPACITY   ACCESS MODES   STORAGECLASS   VOLUMEATTRIBUTESCLASS   AGE
pvc-nfs   Bound    pvc-da1f119d-1636-49ef-a530-929148498d1f   50Mi       RWO            nfs            <unset>                 116s

sysadmin@sysadmin:~$ kubectl get pv
NAME                                       CAPACITY   ACCESS MODES   RECLAIM POLICY   STATUS     CLAIM                                                  STORAGECLASS   VOLUMEATTRIBUTESCLASS   REASON   AGE
data-nfs-server-provisioner-0              1Gi        RWO            Retain           Bound      nfs-server-provisioner/data-nfs-server-provisioner-0                  <unset>                          5m52s
pv1                                        100Mi      RWO            Retain           Released   default/pvc-vol                                                       <unset>                          36m
pvc-da1f119d-1636-49ef-a530-929148498d1f   50Mi       RWO            Delete           Bound      default/pvc-nfs                                        nfs            <unset>                          2m14s
```
3. Проверяем что под пишет и читает файл с тома
в контейнере директива которая пишет в файл и читает из него `command: ['sh', '-c', 'while true; do date >> /folder/output.txt; sleep 5; cat /folder/output.txt; sleep 10; done']`
```
sysadmin@sysadmin:~$ kubectl logs --tail=10 netology-kube-nfs-77d67bdc4-fmz7k multitool 
Tue May 28 12:21:08 UTC 2024
Tue May 28 12:21:23 UTC 2024
Tue May 28 12:21:38 UTC 2024
Tue May 28 12:21:53 UTC 2024
Tue May 28 12:22:08 UTC 2024
Tue May 28 12:22:23 UTC 2024
Tue May 28 12:22:38 UTC 2024
Tue May 28 12:22:53 UTC 2024
Tue May 28 12:23:08 UTC 2024
Tue May 28 12:23:23 UTC 2024
```
------
