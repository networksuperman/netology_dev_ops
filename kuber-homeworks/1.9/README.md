# Домашнее задание к занятию 13.4 «Управление доступом»

### Цель задания

В тестовой среде Kubernetes нужно предоставить ограниченный доступ пользователю.

------

### Задание 1. Создайте конфигурацию для подключения пользователя

1. Создайте и подпишите SSL-сертификат для подключения к кластеру.
2. Настройте конфигурационный файл kubectl для подключения.
3. Создайте роли и все необходимые настройки для пользователя.
4. Предусмотрите права пользователя. Пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`).
5. Предоставьте манифесты и скриншоты и/или вывод необходимых команд.

------

### Решение задания 1.

1. Создаем и подписываем SSL-сертификат для пользователя `testuser` для подключения к кластеру:

```
sysadmin@sysadmin:~$ mkdir certs
sysadmin@sysadmin:~$ cd certs/
sysadmin@sysadmin:~/certs$ openssl genrsa -out testuser.key 2048
sysadmin@sysadmin:~/certs$ openssl req -key testuser.key -new -out testuser.csr -subj "/CN=testuser/O=netology"
sysadmin@sysadmin:~/certs$ openssl x509 -req -in testuser.csr -CA /var/snap/microk8s/current/certs/ca.crt -CAkey /var/snap/microk8s/current/certs/ca.key -CAcreateserial -out testuser.crt -days 365
Certificate request self-signature ok
subject=CN = testuser, O = netology
```
* Проверяем успешность создания сертификата для пользователя `testuser`:
```
sysadmin@sysadmin:~/certs$ ls -l
total 12
-rw-rw-r-- 1 sysadmin sysadmin 1021 Jun  6 12:20 testuser.crt
-rw-rw-r-- 1 sysadmin sysadmin  915 Jun  6 12:20 testuser.csr
-rw------- 1 sysadmin sysadmin 1704 Jun  6 12:20 testuser.key
```
2. Настроим конфигурационный файл kubectl для подключения.
* Сохраним шаблон текущей конфигурации в файл:
```
sysadmin@sysadmin:~/certs$ microk8s config > kubeconfig
sysadmin@sysadmin:~/certs$ ls -l
total 20
-rw-rw-r-- 1 sysadmin sysadmin 5463 Jun  6 12:33 kubeconfig
-rw-rw-r-- 1 sysadmin sysadmin 1021 Jun  6 12:20 testuser.crt
-rw-rw-r-- 1 sysadmin sysadmin  915 Jun  6 12:20 testuser.csr
-rw------- 1 sysadmin sysadmin 1704 Jun  6 12:20 testuser.key
```
* Переключаем конфигурацию kubernetes на созданный файл kubeconfig:
```
sysadmin@sysadmin:~/certs$ export KUBECONFIG=$PWD/kubeconfig
sysadmin@sysadmin:~/certs$ echo $KUBECONFIG
/home/sysadmin/certs/kubeconfig
```
* Вносим изменения в конфигурацию для пользователя `testuser`, создаем контекст `testuser-context` и переключаемся на него:
```
sysadmin@sysadmin:~/certs$ kubectl config set-credentials testuser --client-certificate=testuser.crt --client-key=testuser.key
User "testuser" set.
sysadmin@sysadmin:~/certs$ kubectl config set-context testuser-context --cluster=microk8s-cluster --user=testuser
Context "testuser-context" created.
sysadmin@sysadmin:~/certs$ kubectl config use-context testuser-context
Switched to context "testuser-context".
sysadmin@sysadmin:~/certs$  kubectl config current-context
testuser-context
```
* Проверяем файл с измененной конфигурацией:
```
sysadmin@sysadmin:~/certs$ cat kubeconfig
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: LS0tLS1CRUdJTiBDRVJUSUZJ
    server: https://192.168.6.196:16443
  name: microk8s-cluster
contexts:
- context:
    cluster: microk8s-cluster
    user: admin
  name: microk8s
- context:
    cluster: microk8s-cluster
    user: testuser
  name: testuser-context
current-context: testuser-context
kind: Config
preferences: {}
users:
- name: admin
  user:
    client-certificate-data: LS0tLS1CRUd
    client-key-data: LS0tLS1CRUdJTiBSU0E
- name: testuser
  user:
    client-certificate: testuser.crt
    client-key: testuser.key
```
* Включим поддержку RBAC в MicroK8S:
```
sysadmin@sysadmin:~/certs$ microk8s enable rbac
Infer repository core for addon rbac
Enabling RBAC
Reconfiguring apiserver
Restarting apiserver
RBAC is enabled
```
* Проверим доступность запущенных подов:
```
sysadmin@sysadmin:~/certs$ kubectl get pods
Error from server (Forbidden): pods is forbidden: User "testuser" cannot list resource "pods" in API group "" in the namespace "default"
```
* Видим, что по умолчанию какие-либо действия новому пользователю `testuser` запрещены.

3. Создаем роли и все необходимые настройки для пользователя `testuser`.
* Подготовим следующее yaml-описание для `Role` в файле [role-1.yaml](./role-1.yaml):
```
---
apiVersion: rbac.authorization.k8s.io/v1
kind: Role
metadata:
  name: role-1
  namespace: default
rules:
  - apiGroups: [""]
    resources: ["pods", "pods/log"]
    verbs: ["get", "watch", "list"]
```
* Подготовим следующее yaml-описание для `RoleBinding` в файле [rolebinding-1.yaml](./rolebinding-1.yaml):
```
---
apiVersion: rbac.authorization.k8s.io/v1
kind: RoleBinding
metadata:
  name: rolebinding-1
  namespace: default
subjects:
- kind: User
  name: testuser
  apiGroup: rbac.authorization.k8s.io
roleRef:
  kind: Role
  name: role-1
  apiGroup: rbac.authorization.k8s.io
```
4. Выполняем развертывание созданных ресурсов. Убеждаемся, что пользователь может просматривать логи подов и их конфигурацию (`kubectl logs pod <pod_id>`, `kubectl describe pod <pod_id>`):
* Временно возвращаемся в стандартный контекст `microk8s` с привилегированным пользователем `admin` для kubernetes:
```
sysadmin@sysadmin:~/certs$ kubectl config use-context microk8s
Switched to context "microk8s".
```
* Запускаем развертывание ресурсов `Role` и `RoleBinding`. Проверяем их состояние.
```
sysadmin@sysadmin:~/certs$ kubectl create -f role-1.yaml
role.rbac.authorization.k8s.io/role-1 created
sysadmin@sysadmin:~/certs$ kubectl create -f rolebinding-1.yaml
rolebinding.rbac.authorization.k8s.io/rolebinding-1 created
sysadmin@sysadmin:~/certs$ kubectl describe role role-1
Name:         role-1
Labels:       <none>
Annotations:  <none>
PolicyRule:
  Resources  Non-Resource URLs  Resource Names  Verbs
  ---------  -----------------  --------------  -----
  pods/log   []                 []              [get watch list]
  pods       []                 []              [get watch list]
sysadmin@sysadmin:~/certs$ kubectl describe rolebindings rolebinding-1
Name:         rolebinding-1
Labels:       <none>
Annotations:  <none>
Role:
  Kind:  Role
  Name:  role-1
Subjects:
  Kind  Name      Namespace
  ----  ----      ---------
  User  testuser  
```
* Переключаемся в контекст `testuser-context` с пользователем `testuser`, для которого настроен RBAC:
```
sysadmin@sysadmin:~/certs$ kubectl config use-context testuser-context
Switched to context "testuser-context".
sysadmin@sysadmin:~/certs$ kubectl config current-context
testuser-context
```
* Проверяем возможности пользователя `testuser` по просмотру подов
```
sysadmin@sysadmin:~/certs$ kubectl get pods
NAME    READY   STATUS    RESTARTS   AGE
pod-1   1/1     Running   0          23s
sysadmin@sysadmin:~/certs$ kubectl describe pods pod-1
Name:             pod-1
Namespace:        default
Priority:         0
Service Account:  default
Node:             sysadmin/192.168.6.196
Start Time:       Thu, 06 Jun 2024 12:51:37 +0000
Labels:           app=pod-1
Annotations:      cni.projectcalico.org/containerID: d38ad7e6cb5caeda5d5355c08fea1e61593b733f6b313fbdb0f183644b420b1a
                  cni.projectcalico.org/podIP: 10.1.12.138/32
                  cni.projectcalico.org/podIPs: 10.1.12.138/32
Status:           Running
IP:               10.1.12.138
IPs:
  IP:  10.1.12.138
Containers:
  multitool:
    Container ID:   containerd://cc19cf8486fd0cb6c2f7ef78560cb15e994c6a18a9c430a2323af6a3a19e9d7b
    Image:          wbitt/network-multitool
    Image ID:       docker.io/wbitt/network-multitool@sha256:d1137e87af76ee15cd0b3d4c7e2fcd111ffbd510ccd0af076fc98dddfc50a735
    Port:           <none>
    Host Port:      <none>
    State:          Running
      Started:      Thu, 06 Jun 2024 12:51:40 +0000
    Ready:          True
    Restart Count:  0
    Environment:
      HTTP_PORT:   1080
      HTTPS_PORT:  10443
    Mounts:
      /var/run/secrets/kubernetes.io/serviceaccount from kube-api-access-nbnld (ro)
Conditions:
  Type                        Status
  PodReadyToStartContainers   True 
  Initialized                 True 
  Ready                       True 
  ContainersReady             True 
  PodScheduled                True 
Volumes:
  kube-api-access-nbnld:
    Type:                    Projected (a volume that contains injected data from multiple sources)
    TokenExpirationSeconds:  3607
    ConfigMapName:           kube-root-ca.crt
    ConfigMapOptional:       <nil>
    DownwardAPI:             true
QoS Class:                   BestEffort
Node-Selectors:              <none>
Tolerations:                 node.kubernetes.io/not-ready:NoExecute op=Exists for 300s
                             node.kubernetes.io/unreachable:NoExecute op=Exists for 300s
Events:                      <none>

sysadmin@sysadmin:~/certs$ kubectl logs pod-1
The directory /usr/share/nginx/html is not mounted.
Therefore, over-writing the default index.html file with some useful information:
WBITT Network MultiTool (with NGINX) - pod-1 - 10.1.12.138 - HTTP: 1080 , HTTPS: 10443 . (Formerly praqma/network-multitool)
Replacing default HTTP port (80) with the value specified by the user - (HTTP_PORT: 1080).
Replacing default HTTPS port (443) with the value specified by the user - (HTTPS_PORT: 10443).
```
5. Манифесты и конфигурации представлены в файлах:
[pod-1.yaml](./pod-1.yaml)  
[role-1.yaml](./role-1.yaml)  
[rolebinding-1.yaml](./rolebinding-1.yaml)  
[kubeconfig](./certs/kubeconfig)  
