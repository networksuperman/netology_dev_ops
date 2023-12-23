# Домашнее [задание](https://github.com/netology-code/mnt-homeworks/blob/MNT-video/08-ansible-01-base/README.md) к занятию 1 «Введение в Ansible»

## Основная часть

1. Попробуйте запустить playbook на окружении из `test.yml`, зафиксируйте значение, которое имеет факт `some_fact` для указанного хоста при выполнении playbook.

<details><summary>Решение:</summary>

`some_fact`=`12`
```shell
08-ansible-01-base/playbooks(master)]$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] ************************************************************************************************************************************************************************

TASK [Gathering Facts] ***********************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] ******************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ****************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": 12
}

PLAY RECAP ***********************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

</details>

---

2. Найдите файл с переменными (group_vars), в котором задаётся найденное в первом пункте значение, и поменяйте его на `all default fact`.

<details><summary>Решение:</summary>

`08-ansible-01-base/playbooks/group_vars/all/examp.yml`:
```yaml
---
  some_fact: all default fact
```

```shell
$ ansible-playbook site.yml -i inventory/test.yml

PLAY [Print os facts] *******************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************
ok: [localhost]

TASK [Print OS] *************************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************************************************
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ******************************************************************************************************************************************************************************
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

</details>

---

3. Воспользуйтесь подготовленным (используется `docker`) или создайте собственное окружение для проведения дальнейших испытаний.

<details><summary>Решение:</summary>

```shell
$ docker ps -a
CONTAINER ID   IMAGE                           COMMAND                  CREATED          STATUS                     PORTS     NAMES
69395be4b800   ubuntu:latest                   "tail -f /dev/null"      12 minutes ago   Up 12 minutes                        ubuntu
2c30d921cfca   centos:7                        "tail -f /dev/null"      25 minutes ago   Up 25 minutes                        centos7
```

</details>

---

4. Проведите запуск playbook на окружении из `prod.yml`. Зафиксируйте полученные значения `some_fact` для каждого из `managed host`.

<details><summary>Решение:</summary>

```shell
$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] *******************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el"
}
ok: [ubuntu] => {
    "msg": "deb"
}

PLAY RECAP ******************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

</details>

---

5. Добавьте факты в `group_vars` каждой из групп хостов так, чтобы для `some_fact` получились значения: для `deb` — `deb default fact`, для `el` — `el default fact`.

<details><summary>Решение:</summary>

```shell
$ cat group_vars/{deb,el}/examp.yml
---
  some_fact: "deb default fact"
---
  some_fact: "el default fact"
```

</details>

---

6.  Повторите запуск playbook на окружении `prod.yml`. Убедитесь, что выдаются корректные значения для всех хостов.

<details><summary>Решение:</summary>

```shell
$ ansible-playbook site.yml -i inventory/prod.yml

PLAY [Print os facts] *******************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ******************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

</details>

---

7. При помощи `ansible-vault` зашифруйте факты в `group_vars/deb` и `group_vars/el` с паролем `netology`.

<details><summary>Решение:</summary>

```shell
$ ansible-vault encrypt group_vars/{deb,el}/examp.yml
New Vault password: 
Confirm New Vault password: 
Encryption successful
```

```shell
$ cat group_vars/{deb,el}/examp.yml
$ANSIBLE_VAULT;1.1;AES256
38306163313239376532393663653038306433613563373032653732356661623862373163376339
3161303463363035326266326234393733396330653437350a333437353933353233643133373663
36336565646438303732393664346437333132343665313331323539616135613439326666313934
3939666462323763320a633031313339303331376266396262666466626233643936623832376164
35383938636263633838613134366231386439333435656265376264323730376363396532656537
6538333661613833636338383834373162323937363435643561
$ANSIBLE_VAULT;1.1;AES256
64353164383132333331346430366363333733616634663431653161303139643266333064366634
3830386364313937613364373833383236653161386232360a383031363764336637363732633761
33633465323565373132313766653465653331623130393862376262393137396130383462633535
3064353764626433320a643732343361666537333338376439356536353733383039663939373161
30373632316462396464623032313030653031326661383338363337323864373761643962643732
6536663136306136373565663164356464353966336535623362
```

</details>

---

8. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь в работоспособности.

<details><summary>Решение:</summary>

```shell
$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *******************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************
ok: [ubuntu]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}

PLAY RECAP ******************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

</details>

---

9. Посмотрите при помощи `ansible-doc` список плагинов для подключения. Выберите подходящий для работы на `control node`.

<details><summary>Решение:</summary>

`control node` - машина, с которой идёт управление через ansible
Ищем плагины для подключения (connection), видим большой список. Пробуем отфильтровать по `control`:
```shell
$ ansible-doc -t connection -l | grep -i "control"
ansible.builtin.local          execute on controller
community.docker.nsenter       execute on host running controller container
```

Видимо, нам нужен первый - `ansible.builtin.local`

</details>

---

10. В `prod.yml` добавьте новую группу хостов с именем  `local`, в ней разместите localhost с необходимым типом подключения.

<details><summary>Решение:</summary>

Добавляем в `prod.yml` следующие строки:
```yaml
  local:
    hosts:
      localhost:
        ansible_connection: local
```

</details>

---

11. Запустите playbook на окружении `prod.yml`. При запуске `ansible` должен запросить у вас пароль. Убедитесь, что факты `some_fact` для каждого из хостов определены из верных `group_vars`.

<details><summary>Решение:</summary>

```shell
$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] *******************************************************************************************************************************************************************

TASK [Gathering Facts] ******************************************************************************************************************************************************************
ok: [ubuntu]
ok: [localhost]
ok: [centos7]

TASK [Print OS] *************************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] ***********************************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "all default fact"
}

PLAY RECAP ******************************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0 
```

</details>

---

12. Заполните `README.md` ответами на вопросы. Сделайте `git push` в ветку `master`. В ответе отправьте ссылку на ваш открытый репозиторий с изменённым `playbook` и заполненным `README.md`.

---

## Необязательная часть

1. При помощи `ansible-vault` расшифруйте все зашифрованные файлы с переменными.

<details><summary>Решение:</summary>

```shell
$ ansible-vault decrypt group_vars/{deb,el}/*
Vault password: 
Decryption successful
```

```shell
 cat group_vars/{deb,el}/*
---
  some_fact: "deb default fact"
---
  some_fact: "el default fact"
```

</details>

---

2. Зашифруйте отдельное значение `PaSSw0rd` для переменной `some_fact` паролем `netology`. Добавьте полученное значение в `group_vars/all/exmp.yml`.

<details><summary>Решение:</summary>

```shell
$ ansible-vault encrypt_string
New Vault password: 
Confirm New Vault password: 
Reading plaintext input from stdin. (ctrl-d to end input, twice if your content does not already have a newline)
PaSSw0rd                   
Encryption successful
!vault |
          $ANSIBLE_VAULT;1.1;AES256
          65643633363935323966303932343830313164663062316164303061393432643537376539666131
          3337333139616130663264656131653538633033366439370a343132613838613133636137346630
          30616465646632633236343135376533356333303734333032333531646435306130396666646337
          3461386533363030610a633637666134326162613839396332616537336465356265303933336336
          3735
```

```shell
$ cat group_vars/all/*
---
some_fact: !vault |
  $ANSIBLE_VAULT;1.1;AES256
  65643633363935323966303932343830313164663062316164303061393432643537376539666131
  3337333139616130663264656131653538633033366439370a343132613838613133636137346630
  30616465646632633236343135376533356333303734333032333531646435306130396666646337
  3461386533363030610a633637666134326162613839396332616537336465356265303933336336
  3735
```

</details>

---

3. Запустите `playbook`, убедитесь, что для нужных хостов применился новый `fact`.

<details><summary>Решение:</summary>

```shell
$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ***************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************
ok: [ubuntu]
ok: [localhost]
ok: [centos7]

TASK [Print OS] *********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}

TASK [Print fact] *******************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP **************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

</details>

---

4. Добавьте новую группу хостов `fedora`, самостоятельно придумайте для неё переменную. В качестве образа можно использовать [этот вариант](https://hub.docker.com/r/pycontribs/fedora).

<details><summary>Решение:</summary>

Добавляем в `prod.yml` нашу новую группу 
```yaml
  fed:
    hosts:
      fedora:
        ansible_connection: docker
```

Создаём файл `08-ansible-01-base/playbooks/group_vars/fed/examp.yml` со следующим содержимым:
```yaml
---
  some_fact: "fed default fact"
```

Проверяем:
```shell
$ ansible-playbook site.yml -i inventory/prod.yml --ask-vault-pass
Vault password: 

PLAY [Print os facts] ***************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************
ok: [ubuntu]
ok: [localhost]
ok: [fedora]
ok: [centos7]

TASK [Print OS] *********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] *******************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [fedora] => {
    "msg": "fed default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}

PLAY RECAP **************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0
```

</details>

---

5. Напишите скрипт на bash: автоматизируйте поднятие необходимых контейнеров, запуск ansible-playbook и остановку контейнеров.

<details><summary>Решение:</summary>

Скрипт, пришлось немного попотеть, чтобы сделать его небольшим и поискать, как подтвердить пароль, в итоге проще скормить ансиблу файл с паролем:
```shell
#!/usr/bin/env bash
docker-compose up -d
ansible-playbook site.yml -i inventory/prod.yml --vault-password-file password_file
docker-compose down
```

```shell
$ ./adv.sh
[+] Running 4/4
 ✔ Network playbooks_default  Created                                                                                                                               0.1s 
 ✔ Container ubuntu           Started                                                                                                                               0.1s 
 ✔ Container fedora           Started                                                                                                                               0.1s 
 ✔ Container centos7          Started                                                                                                                               0.1s 

PLAY [Print os facts] ***************************************************************************************************************************************************

TASK [Gathering Facts] **************************************************************************************************************************************************
ok: [localhost]
ok: [ubuntu]
ok: [fedora]
ok: [centos7]

TASK [Print OS] *********************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "CentOS"
}
ok: [ubuntu] => {
    "msg": "Ubuntu"
}
ok: [localhost] => {
    "msg": "Ubuntu"
}
ok: [fedora] => {
    "msg": "Fedora"
}

TASK [Print fact] *******************************************************************************************************************************************************
ok: [centos7] => {
    "msg": "el default fact"
}
ok: [ubuntu] => {
    "msg": "deb default fact"
}
ok: [localhost] => {
    "msg": "PaSSw0rd"
}
ok: [fedora] => {
    "msg": "fed default fact"
}

PLAY RECAP **************************************************************************************************************************************************************
centos7                    : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
fedora                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
localhost                  : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   
ubuntu                     : ok=3    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

[+] Running 4/4
 ✔ Container ubuntu           Removed                                                                                                                              10.5s 
 ✔ Container centos7          Removed                                                                                                                              10.6s 
 ✔ Container fedora           Removed                                                                                                                              10.7s 
 ✔ Network playbooks_default  Removed
```

</details>

---

6. Все изменения должны быть зафиксированы и отправлены в ваш личный репозиторий.

---