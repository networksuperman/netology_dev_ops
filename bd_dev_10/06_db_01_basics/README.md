## Домашнее задание к занятию 1. «Типы и структура СУБД»  

### Задача 1  
Архитектор ПО решил проконсультироваться у вас, какой тип БД лучше выбрать для хранения определённых данных.  
Он вам предоставил следующие типы сущностей, которые нужно будет хранить в БД:  
электронные чеки в json-виде,  
склады и автомобильные дороги для логистической компании,  
генеалогические деревья,  
кэш идентификаторов клиентов с ограниченным временем жизни для движка аутенфикации,  
отношения клиент-покупка для интернет-магазина.  
Выберите подходящие типы СУБД для каждой сущности и объясните свой выбор.  

#### Ответ:  
- Для хранения электронных чеков в формате json используется документоориентированная БД, так как json-документы могут быть использованы в качестве объектов хранения.
- Для логистической компании, которая имеет склады и автомобильные дороги, подходит графовая БД, так как адреса и названия складов могут быть представлены в виде узлов, а дороги между складами - в виде ребер графа.
- Для хранения генеалогических деревьев используется сетевая БД, так как у потомка может быть несколько связей с несколькими родителями.
- Для кэширования идентификаторов клиентов с ограниченным временем жизни для движка аутентификации используется БД формата ключ-значение, где ключ - это идентификатор, а значение - имя клиента. В данном случае можно задать время жизни для каждой записи.
- Для интернет-магазина, который имеет отношения клиент-покупка, используется реляционная БД, так как множество записей о клиентах имеют множество связей с товарами и их свойствами.
  

### Задача 2  
Вы создали распределённое высоконагруженное приложение и хотите классифицировать его согласно CAP-теореме. Какой классификации по CAP-теореме соответствует ваша система, если (каждый пункт — это отдельная реализация вашей системы и для каждого пункта нужно привести классификацию):  
данные записываются на все узлы с задержкой до часа (асинхронная запись);  
при сетевых сбоях система может разделиться на 2 раздельных кластера;  
система может не прислать корректный ответ или сбросить соединение.  
Согласно PACELC-теореме как бы вы классифицировали эти реализации?  

#### Ответ:  
Согласно CAP-теореме:
- Данные записываются на все узлы с задержкой до часа (асинхронная запись) CP обеспечивается согласованность и устойчивость к разделению в ущерб доступности.
- При сетевых сбоях, система может разделиться на 2 раздельных кластера AP обеспечивается доступность и устойчивость к разделению в ущерб согласованности.
- Система может не прислать корректный ответ или сбросить соединение CP обеспечивается согласованность и устойчивость.

Согласно PACELC-теореме:
- Данные записываются на все узлы с задержкой до часа (асинхронная запись) PC/EC
- При сетевых сбоях, система может разделиться на 2 раздельных кластера PA/EL
- Система может не прислать корректный ответ или сбросить соединение PC/EC


### Задача 3  
Могут ли в одной системе сочетаться принципы BASE и ACID? Почему?  

#### Ответ:  
Эти два принципа не могут быть реализованы одновременно, так как они противоречат друг другу. BASE ориентирован на обеспечение высокой производительности системы и доступности данных, в то время как ACID ориентирован на обеспечение сохранности данных и стойкости к разделению.  


Задача 4  
Вам дали задачу написать системное решение, основой которого бы послужили:  
фиксация некоторых значений с временем жизни,  
реакция на истечение таймаута.  
Вы слышали о key-value-хранилище, которое имеет механизм Pub/Sub. Что это за система? Какие минусы выбора этой системы?  

#### Ответ:  
Redis - это СУБД типа key-value, которая может использоваться для реализации кэшей, брокеров сообщений (механизм pub/sub).  
Однако, у Redis есть несколько недостатков.  
- Во-первых, нет гарантий устойчивости системы, особенно учитывая то, что операции по сохранению данных на диск выполняются асинхронно.  
- Во-вторых, для работы с Redis требуется высокая оперативная память сервера, так как данные хранятся в ней.  
- В-третьих, экземпляр БД не масштабируется.  
- В-четвертых, отсутствует разграничение прав по пользователям и доступ предоставляется только по общему логину и паролю.  
- В-пятых, Redis не поддерживает синтаксис языка SQL. Наконец, Redis работает только на одном ядре процессора в однопоточном режиме.  
