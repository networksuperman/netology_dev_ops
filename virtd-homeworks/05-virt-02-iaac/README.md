## Домашнее задание к занятию 2. «Применение принципов IaaC в работе с виртуальными машинами»  

### Задача 1  
Опишите основные преимущества применения на практике IaaC-паттернов.  
Какой из принципов IaaC является основополагающим?  

#### Ответ:  
Основные приемущества применения подхода IaaC это озможность автоматизировать работу администраторов ИТ систем и баз данных и избегать "человеческого" фактора при создании\настройки ИТ ландшафта, появляются возможность автоматически создавать идентичные среды разработки, тестирования и продуктивные среды, время создания и настройки ИТ сред снижается до минут и часов, перенос\миграция\масштабирование происходит контролируемо.  
Основопологающим принципом является управление инфраструктурой через написание кода и затем его исполнение. Такой подход позволяет жестко фиксировать и повторно использовать применяемые параметры, настройки и конфигурации разворачиваемой инфраструктуры.  


### Задача 2  
Чем Ansible выгодно отличается от других систем управление конфигурациями?  
Какой, на ваш взгляд, метод работы систем конфигурации более надёжный — push или pull?  

#### Ответ:  
Ansible отличается:  
Использует подключение по SSH, не надо развертывать новую систему PKI  
Использует метод push, все управляемые хосты будут получать обновления конфигурации, не будет необновленных хостов или мы будем знать, что хост не обновился из-за ошибок.  
обеспечивает Идемпотентное выполнение  
Не требует установки на управляемые хосты  
Расширяемое, существует множество модулей.  
Более надежный на мой взгляд метод push, т.к. он позволяет распростонять изменения на необходимые хосты одномоментно. У зависимого хоста нет варианта не применять обновленную конфигурацию и тем самым повышать вероятность ошибок из-за непримененных изменений.  


### Задача 3  
Установите на личный linux-компьютер(или учебную ВМ с linux):  
VirtualBox,  
Vagrant, рекомендуем версию 2.3.4(в более старших версиях могут возникать проблемы интеграции с ansible)  
Terraform версии 1.5.Х (1.6.х может вызывать проблемы с яндекс-облаком),  
Ansible.  
Приложите вывод команд установленных версий каждой из программ, оформленный в Markdown.  

#### Ответ:  
```
vagrant@vagrant:/var/log$ sudo apt install virtualbox virtualbox-ext-pack
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libfile-basedir-perl libfile-desktopentry-perl libfile-mimeinfo-perl libfontenc1 libfwupdplugin1 libio-stringy-perl libipc-system-simple-perl libnet-dbus-perl libtie-ixhash-perl libu2f-udev
  libx11-protocol-perl libxft2 libxkbfile1 libxml-parser-perl libxml-twig-perl libxml-xpathengine-perl libxmuu1 libxv1 libxxf86dga1 linux-image-5.4.0-91-generic linux-modules-5.4.0-91-generic
  linux-modules-extra-5.4.0-91-generic x11-utils x11-xserver-utils xdg-utils
Use 'sudo apt autoremove' to remove them.
The following additional packages will be installed:
  virtualbox-qt
Suggested packages:
  vde2 virtualbox-guest-additions-iso
The following NEW packages will be installed:
  virtualbox virtualbox-ext-pack virtualbox-qt
0 upgraded, 3 newly installed, 0 to remove and 0 not upgraded.
Need to get 21.8 MB/43.3 MB of archives.
After this operation, 172 MB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://us.archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 virtualbox-ext-pack all 6.1.34-1~ubuntu1.20.04.1 [10.7 kB]
Get:2 http://us.archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 virtualbox-qt amd64 6.1.34-dfsg-3~ubuntu1.20.04.1 [21.8 MB]
Fetched 21.8 MB in 52s (419 kB/s)
Preconfiguring packages ...
Selecting previously unselected package virtualbox.
(Reading database ... 184838 files and directories currently installed.)
Preparing to unpack .../virtualbox_6.1.34-dfsg-3~ubuntu1.20.04.1_amd64.deb ...
Unpacking virtualbox (6.1.34-dfsg-3~ubuntu1.20.04.1) ...
Selecting previously unselected package virtualbox-ext-pack.
Preparing to unpack .../virtualbox-ext-pack_6.1.34-1~ubuntu1.20.04.1_all.deb ...
License has already been accepted.
Unpacking virtualbox-ext-pack (6.1.34-1~ubuntu1.20.04.1) ...
Selecting previously unselected package virtualbox-qt.
Preparing to unpack .../virtualbox-qt_6.1.34-dfsg-3~ubuntu1.20.04.1_amd64.deb ...
Unpacking virtualbox-qt (6.1.34-dfsg-3~ubuntu1.20.04.1) ...
Setting up virtualbox (6.1.34-dfsg-3~ubuntu1.20.04.1) ...
Setting up virtualbox-ext-pack (6.1.34-1~ubuntu1.20.04.1) ...
virtualbox-ext-pack: downloading: https://download.virtualbox.org/virtualbox/6.1.34/Oracle_VM_VirtualBox_Extension_Pack-6.1.34.vbox-extpack
The file will be downloaded into /usr/share/virtualbox-ext-pack
License accepted.
0%...10%...20%...30%...40%...50%...60%...70%...80%...90%...100%
Successfully installed "Oracle VM VirtualBox Extension Pack".
Setting up virtualbox-qt (6.1.34-dfsg-3~ubuntu1.20.04.1) ...
Processing triggers for mime-support (3.64ubuntu1) ...
Processing triggers for hicolor-icon-theme (0.17-2) ...
Processing triggers for systemd (245.4-4ubuntu3.17) ...
Processing triggers for man-db (2.9.1-1) ...
Processing triggers for shared-mime-info (1.15-1) ...
```
```
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add - sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main" sudo apt-get update && sudo apt-get install vagrant
```
```
vagrant@vagrant:~$ curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
OK
vagrant@vagrant:~$ sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
Get:1 https://apt.releases.hashicorp.com focal InRelease [16.3 kB]
Hit:2 https://dl.google.com/linux/chrome/deb stable InRelease
Hit:3 http://us.archive.ubuntu.com/ubuntu focal InRelease
Get:4 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease [114 kB]
Get:5 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:6 https://apt.releases.hashicorp.com focal/main amd64 Packages [58.2 kB]
Get:7 http://us.archive.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Get:8 http://us.archive.ubuntu.com/ubuntu focal-updates/main amd64 Packages [1,946 kB]
Get:9 http://us.archive.ubuntu.com/ubuntu focal-updates/universe amd64 Packages [924 kB]
Get:10 http://us.archive.ubuntu.com/ubuntu focal-updates/multiverse amd64 Packages [24.5 kB]
Fetched 3,305 kB in 14s (241 kB/s)
Reading package lists... Done
vagrant@vagrant:~$ sudo apt-get update && sudo apt-get install vagrant
Hit:1 https://dl.google.com/linux/chrome/deb stable InRelease
Hit:2 http://us.archive.ubuntu.com/ubuntu focal InRelease
Hit:3 https://apt.releases.hashicorp.com focal InRelease
Hit:4 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease
Get:5 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:6 http://us.archive.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Fetched 222 kB in 4s (56.5 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libfile-basedir-perl libfile-desktopentry-perl libfile-mimeinfo-perl libfontenc1 libfwupdplugin1 libio-stringy-perl libipc-system-simple-perl libnet-dbus-perl libtie-ixhash-perl libu2f-udev
  libx11-protocol-perl libxft2 libxkbfile1 libxml-parser-perl libxml-twig-perl libxml-xpathengine-perl libxmuu1 libxv1 libxxf86dga1 linux-image-5.4.0-91-generic linux-modules-5.4.0-91-generic
  linux-modules-extra-5.4.0-91-generic x11-utils x11-xserver-utils xdg-utils
Use 'sudo apt autoremove' to remove them.
The following NEW packages will be installed:
  vagrant
0 upgraded, 1 newly installed, 0 to remove and 0 not upgraded.
Need to get 41.5 MB of archives.
After this operation, 117 MB of additional disk space will be used.
Get:1 https://apt.releases.hashicorp.com focal/main amd64 vagrant amd64 2.2.19 [41.5 MB]
Fetched 41.5 MB in 14s (2,929 kB/s)
Selecting previously unselected package vagrant.
(Reading database ... 185208 files and directories currently installed.)
Preparing to unpack .../vagrant_2.2.19_amd64.deb ...
Unpacking vagrant (2.2.19) ...
Setting up vagrant (2.2.19) ...
vagrant@vagrant:~$
```
```
vagrant@vagrant:~$ vagrant --version
Vagrant 2.2.19
```
```
vagrant@vagrant:~$ sudo apt-get update && sudo apt-get install vagrant
Hit:1 https://dl.google.com/linux/chrome/deb stable InRelease
Hit:2 http://us.archive.ubuntu.com/ubuntu focal InRelease
Hit:3 https://apt.releases.hashicorp.com focal InRelease
Hit:4 http://us.archive.ubuntu.com/ubuntu focal-updates InRelease
Get:5 http://us.archive.ubuntu.com/ubuntu focal-backports InRelease [108 kB]
Get:6 http://us.archive.ubuntu.com/ubuntu focal-security InRelease [114 kB]
Fetched 222 kB in 4s (56.5 kB/s)
Reading package lists... Done
Reading package lists... Done
Building dependency tree
Reading state information... Done
The following packages were automatically installed and are no longer required:
  libfile-basedir-perl libfile-desktopentry-perl libfile-mimeinfo-perl libfontenc1 libfwupdplugin1 libio-stringy-perl libipc-system-simple-perl libnet-dbus-perl libtie-ixhash-perl libu2f-udev
  libx11-protocol-perl libxft2 libxkbfile1 libxml-parser-perl libxml-twig-perl libxml-xpathengine-perl libxmuu1 libxv1 libxxf86dga1 linux-image-5.4.0-91-generic linux-modules-5.4.0-91-generic
Unpacking ansible (2.9.6+dfsg-1) ...
Selecting previously unselected package python3-argcomplete.
Preparing to unpack .../03-python3-argcomplete_1.8.1-1.3ubuntu1_all.deb ...
Unpacking python3-argcomplete (1.8.1-1.3ubuntu1) ...
Selecting previously unselected package python3-jmespath.
Preparing to unpack .../04-python3-jmespath_0.9.4-2ubuntu1_all.deb ...
Unpacking python3-jmespath (0.9.4-2ubuntu1) ...
Selecting previously unselected package python3-kerberos.
Preparing to unpack .../05-python3-kerberos_1.1.14-3.1build1_amd64.deb ...
Unpacking python3-kerberos (1.1.14-3.1build1) ...
Selecting previously unselected package python3-lockfile.
Preparing to unpack .../06-python3-lockfile_1%3a0.12.2-2ubuntu2_all.deb ...
Unpacking python3-lockfile (1:0.12.2-2ubuntu2) ...
Selecting previously unselected package python3-libcloud.
Preparing to unpack .../07-python3-libcloud_2.8.0-1_all.deb ...
Unpacking python3-libcloud (2.8.0-1) ...
Selecting previously unselected package python3-ntlm-auth.
Preparing to unpack .../08-python3-ntlm-auth_1.1.0-1_all.deb ...
Unpacking python3-ntlm-auth (1.1.0-1) ...
Selecting previously unselected package python3-requests-kerberos.
Preparing to unpack .../09-python3-requests-kerberos_0.12.0-2_all.deb ...
Unpacking python3-requests-kerberos (0.12.0-2) ...
Selecting previously unselected package python3-requests-ntlm.
Preparing to unpack .../10-python3-requests-ntlm_1.1.0-1_all.deb ...
Unpacking python3-requests-ntlm (1.1.0-1) ...
Selecting previously unselected package python3-selinux.
Preparing to unpack .../11-python3-selinux_3.0-1build2_amd64.deb ...
Unpacking python3-selinux (3.0-1build2) ...
Selecting previously unselected package python3-xmltodict.
Preparing to unpack .../12-python3-xmltodict_0.12.0-1_all.deb ...
Unpacking python3-xmltodict (0.12.0-1) ...
Selecting previously unselected package python3-winrm.
Preparing to unpack .../13-python3-winrm_0.3.0-2_all.deb ...
Unpacking python3-winrm (0.3.0-2) ...
Setting up python3-lockfile (1:0.12.2-2ubuntu2) ...
Setting up python3-ntlm-auth (1.1.0-1) ...
Setting up python3-kerberos (1.1.14-3.1build1) ...
Setting up python3-xmltodict (0.12.0-1) ...
Setting up python3-jmespath (0.9.4-2ubuntu1) ...
Setting up python3-requests-kerberos (0.12.0-2) ...
Setting up python3-dnspython (1.16.0-1build1) ...
Setting up python3-selinux (3.0-1build2) ...
Setting up python3-crypto (2.6.1-13ubuntu2) ...
Setting up ansible (2.9.6+dfsg-1) ...
Setting up python3-argcomplete (1.8.1-1.3ubuntu1) ...
Setting up python3-requests-ntlm (1.1.0-1) ...
Setting up python3-libcloud (2.8.0-1) ...
Setting up python3-winrm (0.3.0-2) ...
Processing triggers for man-db (2.9.1-1) ...
```
```
vagrant@vagrant:~$ ansible --version
ansible 2.9.6
  config file = /etc/ansible/ansible.cfg
  configured module search path = ['/home/vagrant/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /usr/lib/python3/dist-packages/ansible
  executable location = /usr/bin/ansible
  python version = 3.8.10 (default, Mar 15 2022, 12:22:08) [GCC 9.4.0]
```

### Задача 4  
Воспроизведите практическую часть лекции самостоятельно.  
Создайте виртуальную машину.  
Зайдите внутрь ВМ, убедитесь, что Docker установлен с помощью команды  
docker ps,  
Vagrantfile из лекции и код ansible находятся в папке.  
Примечание. Если Vagrant выдаёт ошибку:  
URL: ["https://vagrantcloud.com/bento/ubuntu-20.04"]       
Error: The requested URL returned error: 404:  
выполните следующие действия:  
Скачайте с сайта файл-образ "bento/ubuntu-20.04".  
Добавьте его в список образов Vagrant: "vagrant box add bento/ubuntu-20.04 <путь к файлу>".  
Важно!: Если ваша хостовая рабочая станция - это windows ОС, то у вас могут возникнуть проблемы со вложенной виртуализацией. способы решения . Если вы устанавливали hyper-v или docker desktop то все равно может возникать ошибка: Stderr: VBoxManage: error: AMD-V VT-X is not available (VERR_SVM_NO_SVM) . Попробуйте в этом случае выполнить в windows от администратора команду: "bcdedit /set hypervisorlaunchtype off" и перезагрузиться  
Приложите скриншоты в качестве решения на эту задачу. Допускается неполное выполнение данного задания если не сможете совладать с Windows.  

#### Ответ:  
```
docker ps
```
```
vagrant@vagrant:~$ export VAGRANT_DEFAULT_PROVIDER=virtualbox
vagrant@vagrant:~$ vagrant box add bento/ubuntu-20.04 --provider=virtualbox --force
==> box: Loading metadata for box 'bento/ubuntu-20.04'
    box: URL: https://vagrantcloud.com/bento/ubuntu-20.04
==> box: Adding box 'bento/ubuntu-20.04' (v202206.03.0) for provider: virtualbox
    box: Downloading: https://vagrantcloud.com/bento/boxes/ubuntu-20.04/versions/202206.03.0/providers/virtualbox.box
==> box: Successfully added box 'bento/ubuntu-20.04' (v202206.03.0) for 'virtualbox'!
vagrant@vagrant:~$ vagrant box list
bento/ubuntu-20.04 (virtualbox, 202206.03.0)
```
```
vagrant@vagrant:~$ cd virtual_machine/
vagrant@vagrant:~/virtual_machine$ vagrant init
A `Vagrantfile` has been placed in this directory. You are now
ready to `vagrant up` your first virtual environment! Please read
the comments in the Vagrantfile as well as documentation on
`vagrantup.com` for more information on using Vagrant.
vagrant@vagrant:~/virtual_machine$ ls -al
total 12
drwxrwxr-x  2 vagrant vagrant 4096 Jul  5 20:49 .
drwxr-xr-x 19 vagrant vagrant 4096 Jul  5 20:49 ..
-rw-rw-r--  1 vagrant vagrant 3010 Jul  5 20:49 Vagrantfile
```
