# 100　プレイグラウンド
## なにするだ
プレイグラウンド環境を理解します。環境の概要は下記のとおりです

[ 概要図 ]

`profile` が `extra` になっているものは自動起動しません

### 起動するやつリスト
| service | hostname  | image         | profile | note          |
| ------- | --------- | ------------- | ------- | ------------- |
| mysql84 | (dynamic) | mysql:8.4     | extra   | root パスなし |
| mysql80 | (dynamic) | mysql:8.0     |         | root パスなし |
| mysql57 | (dynamic) | mysql:5.7     | extra   | root パスなし |
| mysql56 | (dynamic) | mysql:5.6     | extra   | root パスなし |
| ladder  | (dynamic) | ladder:latest |         | root パスなし |
| mysql   | (dynamic) | ladder:latest | extra   |               |

## シナリオ
1. 環境を起動する
2. ladder に接続する
3. MySQL 8.0 に接続する
4. MySQL 8.4 に接続する
5. client で接続する
6. 環境を停止し削除する

## やってみよう
### 環境を起動する
`docker compose` で環境を起動します。`mysql80` と `ladder` コンテナが起動します
```sh
~/mysql-playground/100$ docker compose up -d
[+] Running 2/2
 ✔ Container 100-ladder-1   Started                                                    0.5s 
 ✔ Container 100-mysql80-1  Started                                                    0.5s
```

### ladder に接続する
起動した `mysql80` は ポートを露出してないので `ladder` に接続してから `mysql コマンド` を叩きます  
`ladder` が露出しているポートを確認するには `docker compose port` を使います
```sh
~/mysql-playground/100$ docker compose port ladder 22
0.0.0.0:32770
```
ssh は `root` で接続可能です
```sh
~/mysql-playground/100$ ssh -o StrictHostKeyChecking=no localhost -l root -p 32770 
Warning: Permanently added '[localhost]:32770' (ED25519) to the list of known hosts.
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

69fffcd2592b:~#
```

### MySQL 8.0 に接続する
`ladder` に接続したら `mysql` で起動した `mysql80` に接続してみましょう
```sh
69fffcd2592b:~# mysql -h mysql80
Welcome to the MariaDB monitor.  Commands end with ; or \g.
Your MySQL connection id is 8
Server version: 8.0.37 MySQL Community Server - GPL

Copyright (c) 2000, 2018, Oracle, MariaDB Corporation Ab and others.

Type 'help;' or '\h' for help. Type '\c' to clear the current input statement.

MySQL [(none)]>
MySQL [(none)]> select @@version;
+-----------+
| @@version |
+-----------+
| 8.0.37    |
+-----------+
1 row in set (0.000 sec)

MySQL [(none)]> \q
Bye
69fffcd2592b:~# exit
logout
Connection to localhost closed.
~/mysql-playground/100$ 
```

### MySQL 8.4 に接続する
`mysql84` は起動していないので別途起動します
```sh
~/mysql-playground/100$ docker compose up -d mysql84
[+] Running 1/1
 ✔ Container 100-mysql84-1  Started                                                      0.2s
 ```
 接続の仕方は同様です
 ```sh
~/mysql-playground/100$ ssh -o StrictHostKeyChecking=no localhost -l root -p 32770
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

69fffcd2592b:~# mysql -h mysql84 -e "select @@version;"
+-----------+
| @@version |
+-----------+
| 8.4.0     |
+-----------+
69fffcd2592b:~# exit
logout
Connection to localhost closed.
~/mysql-playground/100$ 
 ```

### client で接続する
`mysql` クライアントイメージを利用して SSH 越しではなくコンテナへ直接コマンド発行も可能です  
確認しておきましょう
```sh
~/mysql-playground/100$ docker compose run --rm mysql -h mysql80 -e "select @@hostname;"
+--------------+
| @@hostname   |
+--------------+
| 1b9ef4985590 |
+--------------+
~/mysql-playground/100$ docker compose run --rm mysql -h mysql84 -e "select @@hostname;"
+--------------+
| @@hostname   |
+--------------+
| 8e86e31d5341 |
+--------------+
~/mysql-playground/100$ 
```
### 環境を停止し削除する
一通りの環境への理解が得られたら環境を停止し削除します
```sh
~/mysql-playground/100$ docker compose stop
[+] Stopping 2/2
 ✔ Container 100-mysql80-1  Stopped                                                      1.8s 
 ✔ Container 100-ladder-1   Stopped                                                      0.4s

 ~/mysql-playground/100$ docker compose rm -f
Going to remove 100-mysql80-1, 100-ladder-1
[+] Removing 2/0
 ✔ Container 100-ladder-1   Removed                                                       0.0s 
 ✔ Container 100-mysql80-1  Removed                                                       0.0s
```

個別に起動したコンテナも削除しておきましょう
```sh
~/mysql-playground/100$ docker compose ps
NAME            IMAGE       COMMAND                  SERVICE   CREATED          STATUS         PORTS
100-mysql84-1   mysql:8.4   "docker-entrypoint.s…"   mysql84   12 minutes ago   Up 9 minutes   3306/tcp, 33060/tcp
~/mysql-playground/100$
~/mysql-playground/100$
~/mysql-playground/100$ docker compose stop mysql84
[+] Stopping 1/1
 ✔ Container 100-mysql84-1  Stopped                                                       1.3s 
~/mysql-playground/100$ docker compose rm mysql84
? Going to remove 100-mysql84-1 Yes
[+] Removing 1/0
 ✔ Container 100-mysql84-1  Removed                                                       0.0s
 ~/mysql-playground/100$ 
```
