### Домашнее задание к занятию «Инструменты Git»  

### Задание  
В клонированном репозитории:  
Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea.  
Ответьте на вопросы.  
Какому тегу соответствует коммит 85024d3?  
Сколько родителей у коммита b8d720? Напишите их хеши.  
Перечислите хеши и комментарии всех коммитов, которые были сделаны между тегами v0.12.23 и v0.12.24.  
Найдите коммит, в котором была создана функция func providerSource, её определение в коде выглядит так: func providerSource(...) (вместо троеточия перечислены аргументы).  
Найдите все коммиты, в которых была изменена функция globalPluginDirs.  
Кто автор функции synchronizedWriters?  

#### Ответ:  
1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea  
```
git show aefea
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/git/img-git-4/git4_1.png)  
2. Какому тегу соответствует коммит 85024d3?  
```
git log -1 85024d3
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/git/img-git-4/git4_2.png)  
3. Сколько родителей у коммита b8d720? Напишите их хеши  
Простой git log вызов для фиксации слияния показывает сокращенные хэши своих родителей:  
```
git log -1 b8d720
```
git выводит родителей в соответствии с их количеством: первый (крайний слева) хеш - для первого родителя и так далее  
Если нужны только хэши, есть два варианта:
```
git log --pretty=%P -n 1 b8d720
или
git show -s --pretty=%P b8d720

```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/git/img-git-4/git4_3.png)  
4. Перечислите хеши и комментарии всех коммитов, которые были сделаны между тегами v0.12.23 и v0.12.24
```
git log v0.12.23..v0.12.24 --pretty=oneline
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/git/img-git-4/git4_4.png)  
5. Найдите коммит, в котором была создана функция func providerSource, её определение в коде выглядит так: func providerSource(...) (вместо троеточия перечислены аргументы)  
```
git log -S 'func providerSource'
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/git/img-git-4/git4_5.png)  
6. Найдите все коммиты, в которых была изменена функция globalPluginDirs.  
```
git log -GglobalPluginDirs --stat
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/git/img-git-4/git4_6.png)  
7. Кто автор функции synchronizedWriters?  
```
git log -S synchronizedWriters --pretty=format:"%h %an"
```
![](https://github.com/networksuperman/netology_dev_ops/blob/main/git/img-git-4/git4_7.png)  
