# Group Replication のリカバリ <!-- omit in toc -->
- [更新中にPRIMARYが外れた場合](#更新中にprimaryが外れた場合)


## やってみよう <!-- omit in toc -->

## 更新中にPRIMARYが外れた場合
更新中に`PRIMARY`メンバが外れてが移行した場合を考えてみよう
まずは起動  
```sh
~/mysql-playground/07GroupReplication$ docker compose up -d
[+] Running 5/5
 ✔ Container gr80-ladder-1  Started                                                            0.5s 
 ✔ Container gr80-node1-1   Healthy                                                            6.8s 
 ✔ Container gr80-node2-1   Healthy                                                           21.8s 
 ✔ Container gr80-node3-1   Healthy                                                           21.3s 
 ✔ Container gr80-initer-1  Started                                                           22.0s
```

マスタで更新用の下準備
```sh
~/mysql-playground/07GroupReplication$ docker compose run --rm mysql -h node1 \
 -e "create database hoge;" \
 -e "use hoge;" \
 -e "create table tab (id bigint not null primary key auto_increment, data datetime );"
```

マスタへ更新
```sh
~/mysql-playground/07GroupReplication$ docker compose exec ladder bash -c \
'for i in {1..100}; do mysql -h node1 -e "insert into hoge.tab (data) values (now())"; sleep 1; done'
```

master
```sh
MySQL [(none)]> select * from hoge.tab order by id desc limit 10;
+----+---------------------+
| id | data                |
+----+---------------------+
| 94 | 2024-07-04 09:28:51 |
| 93 | 2024-07-04 09:28:50 |
| 92 | 2024-07-04 09:28:49 |
| 91 | 2024-07-04 09:28:48 |
| 90 | 2024-07-04 09:28:47 |
| 89 | 2024-07-04 09:28:46 |
| 88 | 2024-07-04 09:28:45 |
| 87 | 2024-07-04 09:28:44 |
| 86 | 2024-07-04 09:28:43 |
| 85 | 2024-07-04 09:28:42 |
+----+---------------------+
10 rows in set (0.000 sec)

```

```sh
docker compose stop node1
```

# Reference <!-- omit in toc -->
* 