# Домашнее задание к занятию «Как работает сеть в K8s»

### Цель задания

Настроить сетевую политику доступа к подам.

### Чеклист готовности к домашнему заданию

1. Кластер K8s с установленным сетевым плагином Calico.

### Инструменты и дополнительные материалы, которые пригодятся для выполнения задания

1. [Документация Calico](https://www.tigera.io/project-calico/).
2. [Network Policy](https://kubernetes.io/docs/concepts/services-networking/network-policies/).
3. [About Network Policy](https://docs.projectcalico.org/about/about-network-policy).

-----

### Задание 1. Создать сетевую политику или несколько политик для обеспечения доступа

1. Создать deployment'ы приложений frontend, backend и cache и соответсвующие сервисы.
2. В качестве образа использовать network-multitool.
3. Разместить поды в namespace App.
4. Создать политики, чтобы обеспечить доступ frontend -> backend -> cache. Другие виды подключений должны быть запрещены.
5. Продемонстрировать, что трафик разрешён и запрещён.

------

### Решение  

1. Создадим виртуальные машины в Яндекс Облако: 1 master и 3 worker ноды.
![](./images/kuber-net-1.png)  

2. На `kube-master-01` выполняем:

* Подготовим kubespray (для переменной `IPS` указываем IP-адреса виртуальных машин в Яндекс Облако, начиная с мастер-ноды):
```
apt-get update -y
apt-get install git pip -y
git clone https://github.com/kubernetes-sigs/kubespray
cd kubespray
pip3 install -r requirements.txt
cp -rfp inventory/sample inventory/mycluster
declare -a IPS=(192.168.0.3 192.168.0.24 192.168.0.42 192.168.0.14)
```
* Генерируем inventory-файл `hosts.yaml` для Ansible с использованием заданной переменной `IPS`:
```
root@kube-master-01:~/kubespray# CONFIG_FILE=inventory/mycluster/hosts.yaml python3 contrib/inventory_builder/inventory.py ${IPS[@]}
DEBUG: Adding group all
DEBUG: Adding group kube_control_plane
DEBUG: Adding group kube_node
DEBUG: Adding group etcd
DEBUG: Adding group k8s_cluster
DEBUG: Adding group calico_rr
DEBUG: adding host node1 to group all
DEBUG: adding host node2 to group all
DEBUG: adding host node3 to group all
DEBUG: adding host node4 to group all
DEBUG: adding host node1 to group etcd
DEBUG: adding host node2 to group etcd
DEBUG: adding host node3 to group etcd
DEBUG: adding host node1 to group kube_control_plane
DEBUG: adding host node2 to group kube_control_plane
DEBUG: adding host node1 to group kube_node
DEBUG: adding host node2 to group kube_node
DEBUG: adding host node3 to group kube_node
DEBUG: adding host node4 to group kube_node
```
* В inventory-файл `hosts.yaml` сделает так, чтобы `node1` был master, остальные - worker. Etcd оставляем только на мастере:
```
root@kube-master-01:~/kubespray# cat inventory/mycluster/hosts.yaml
all:
  hosts:
    node1:
      ansible_host: 192.168.0.3
      ip: 192.168.0.3
      access_ip: 192.168.0.3
    node2:
      ansible_host: 192.168.0.24
      ip: 192.168.0.24
      access_ip: 192.168.0.24
    node3:
      ansible_host: 192.168.0.42
      ip: 192.168.0.42
      access_ip: 192.168.0.42
    node4:
      ansible_host: 192.168.0.14
      ip: 192.168.0.14
      access_ip: 192.168.0.14
  children:
    kube_control_plane:
      hosts:
        node1:
    kube_node:
      hosts:
        node2:
        node3:
        node4:
    etcd:
      hosts:
        node1:
    k8s_cluster:
      children:
        kube_control_plane:
        kube_node:
    calico_rr:
      hosts: {}
```
* Копируем закрытый ключ на master:
```
rsync --rsync-path="sudo rsync" /root/.ssh/id_rsa admin@51.250.90.121:/root/.ssh/id_rsa
```
Проверим
```
root@kube-master-01:~# ls .ssh/
authorized_keys  id_rsa
```
3. Применяем конфигурацию Ansible для узлов кластера и создадим kubeconfig-файл для пользователя admin:
```
root@kube-master-01:~/kubespray# ansible-playbook -i inventory/mycluster/hosts.yaml -u admin -b -v --private-key=/root/.ssh/id_rsa cluster.yml
------ ВЫВОД ------
TASK [network_plugin/calico : Check if inventory match current cluster configuration] *******************************************************************************************************************************************************
ok: [node1] => {
    "changed": false,
    "msg": "All assertions passed"
}
Tuesday 18 June 2024 10:15:23 +0000 (0:00:00.131)       0:19:43.797 ********
Tuesday 18 June 2024 10:15:23 +0000 (0:00:00.060)       0:19:43.858 ********
Tuesday 18 June 2024 10:15:23 +0000 (0:00:00.045)       0:19:43.903 ********

PLAY RECAP **********************************************************************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
node1                      : ok=754  changed=150  unreachable=0    failed=0    skipped=1280 rescued=0    ignored=8
node2                      : ok=514  changed=94   unreachable=0    failed=0    skipped=780  rescued=0    ignored=1
node3                      : ok=514  changed=94   unreachable=0    failed=0    skipped=779  rescued=0    ignored=1
node4                      : ok=514  changed=94   unreachable=0    failed=0    skipped=779  rescued=0    ignored=1
```
* Создадим и настроим kubeconfig-файла для пользователя admin:
```
admin@kube-master-01:~$ mkdir -p $HOME/.kube
admin@kube-master-01:~$ sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
admin@kube-master-01:~$ sudo chown $(id -u):$(id -g) $HOME/.kube/config
```
4. Проверим состояние нод в кластере Kubernetes:
```
admin@kube-master-01:~$ kubectl get nodes
NAME    STATUS   ROLES           AGE     VERSION
node1   Ready    control-plane   9m27s   v1.28.2
node2   Ready    <none>          8m34s   v1.28.2
node3   Ready    <none>          8m29s   v1.28.2
node4   Ready    <none>          8m29s   v1.28.2
```
5. Проверим состояние подов в кластере Kubernetes. Видим в списке подов, что в качестве сетевого плагина используется calico. 
```
admin@kube-master-01:~$ kubectl get po -A
NAMESPACE     NAME                                       READY   STATUS    RESTARTS   AGE
kube-system   calico-kube-controllers-5fb8ccdcd6-kmxjj   1/1     Running   0          14m
kube-system   calico-node-5qcv4                          1/1     Running   0          16m
kube-system   calico-node-7949w                          1/1     Running   0          16m
kube-system   calico-node-9msxv                          1/1     Running   0          16m
kube-system   calico-node-dgs7f                          1/1     Running   0          16m
kube-system   coredns-67cb94d654-bkv4s                   1/1     Running   0          14m
kube-system   coredns-67cb94d654-jkc25                   1/1     Running   0          14m
kube-system   dns-autoscaler-7b6c6d8b5b-2j9jg            1/1     Running   0          14m
kube-system   kube-apiserver-node1                       1/1     Running   1          17m
kube-system   kube-controller-manager-node1              1/1     Running   2          17m
kube-system   kube-proxy-hrgfk                           1/1     Running   0          16m
kube-system   kube-proxy-mgdwl                           1/1     Running   0          16m
kube-system   kube-proxy-q256j                           1/1     Running   0          16m
kube-system   kube-proxy-vcfr7                           1/1     Running   0          16m
kube-system   kube-scheduler-node1                       1/1     Running   1          17m
kube-system   nginx-proxy-node2                          1/1     Running   0          16m
kube-system   nginx-proxy-node3                          1/1     Running   0          16m
kube-system   nginx-proxy-node4                          1/1     Running   0          16m
kube-system   nodelocaldns-22lvx                         1/1     Running   0          14m
kube-system   nodelocaldns-82xrs                         1/1     Running   0          14m
kube-system   nodelocaldns-8wqtz                         1/1     Running   0          14m
kube-system   nodelocaldns-s6w8x                         1/1     Running   0          14m
```
6. Создадим namespace `app`
* Опишем конфигурационный файл namespace.yaml:
```
admin@kube-master-01:~$ cat namespace.yaml
apiVersion: v1
kind: Namespace
metadata:
  name: app
```
* Применим конфигурацию:
```
admin@kube-master-01:~$ kubectl create -f namespace.yaml
namespace/app created
admin@kube-master-01:~$ kubectl get namespaces
NAME              STATUS   AGE
app               Active   15s
default           Active   35m
kube-node-lease   Active   35m
kube-public       Active   35m
kube-system       Active   35m
```
7. Создадим deployment и service для приложения `frontend`:
* Опишем конфигурационный файл deployment-frontend.yaml:
```
admin@kube-master-01:~$ cat deployment-frontend.yaml
---
apiVersion: apps/v1
kind: Deployment
metadata:
  labels:
    app: deployment-frontend
  name: deployment-frontend
  namespace: app
spec:
  replicas: 1
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      containers:
        - name: frontend-multitool
          image: wbitt/network-multitool
```
* Опишем конфигурационный файл service-frontend.yaml:
```
admin@kube-master-01:~$ cat service-frontend.yaml
---
apiVersion: v1
kind: Service
metadata:
  name: service-frontend
  namespace: app
spec:
  selector:
    app: frontend
  ports:
    - name: port-80
      port: 80
      targetPort: 80
```
* Применим deployment и service для приложения `frontend`:
```
admin@kube-master-01:~$ kubectl create -f deployment-frontend.yaml
deployment.apps/deployment-frontend created
admin@kube-master-01:~$ kubectl create -f service-frontend.yaml
service/service-frontend created
```
