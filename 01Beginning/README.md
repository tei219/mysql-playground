# 100　プレイグラウンド
## なにするだ
プレイグラウンド環境を理解します。環境の概要は下記のとおりです

[ 概要図 ]

各コンテナのパスワードは **なし** で作ってますです  

### 起動するやつリスト 
| service | hostname  | image         | profile | note          |
| ------- | --------- | ------------- | ------- | ------------- |
| mysql84 | (dynamic) | mysql:8.4     | extra   | パスなし      |
| mysql80 | (dynamic) | mysql:8.0     |         | パスなし      |
| mysql57 | (dynamic) | mysql:5.7     | extra   | パスなし      |
| mysql56 | (dynamic) | mysql:5.6     | extra   | パスなし      |
| ladder  | (dynamic) | ladder:latest |         | パスなし sshd |
| mysql   | (dynamic) | ladder:latest | extra   |               |

※`profile` が `extra` になっているものは自動起動しません  

## シナリオ
1. 環境を起動する
2. ladder に接続する
3. MySQL 8.0 に接続する
4. MySQL 8.4 に接続する
5. mysql-client で接続する
6. 環境を停止し削除する

## やってみよう
### 環境を起動する
`docker compose up -d` で環境を起動します。`mysql80` と `ladder` コンテナが起動します
```sh
~/mysql-playground/01Beginning$ docker compose up -d
[+] Running 3/3
 ✔ Network playground_default      Created                                                  0.2s 
 ✔ Container playground-ladder-1   Started                                                  0.5s 
 ✔ Container playground-mysql80-1  Started                                                  0.4s
```

### ladder に接続する
起動した `mysql80` は ポートを露出してないので `ladder` に接続してから `mysql コマンド` を叩きます  
`ladder` が露出しているポートを確認するには `docker compose port` を使います
```sh
~/mysql-playground/01Beginning$ docker compose port ladder 22
0.0.0.0:32777
```
ssh は `root` で接続可能です
```sh
~/mysql-playground/01Beginning$ ssh -o StrictHostKeyChecking=no localhost -l root -p 32777
Warning: Permanently added '[localhost]:32777' (ED25519) to the list of known hosts.
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

fc14c25a9ca8:~#
```

### MySQL 8.0 に接続する
`ladder` に接続したら `mysql` で起動した `mysql80` に接続してみましょう
```sh
fc14c25a9ca8:~# mysql -h mysql80
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
fc14c25a9ca8:~# exit
logout
Connection to localhost closed.
```

### MySQL 8.4 に接続する
`mysql84` は起動していないので別途起動します
```sh
~/mysql-playground/01Beginning$ docker compose up -d mysql84
[+] Running 1/1
 ✔ Container playground-mysql84-1  Started                                                  0.3s
 ```
 接続の仕方は同様です
 ```sh
~/mysql-playground/01Beginning$ ssh -o StrictHostKeyChecking=no localhost -l root -p 32777
Welcome to Alpine!

The Alpine Wiki contains a large amount of how-to guides and general
information about administrating Alpine systems.
See <https://wiki.alpinelinux.org/>.

You can setup the system with the command: setup-alpine

You may change this message by editing /etc/motd.

fc14c25a9ca8:~# mysql -h mysql84 -e "select @@version;"
+-----------+
| @@version |
+-----------+
| 8.4.0     |
+-----------+
fc14c25a9ca8:~# exit
logout
Connection to localhost closed.
 ```

### mysql-client で直接接続する
`mysql` クライアントイメージを利用して SSH 越しではなく、コンテナへ直接コマンド発行も可能です  
確認しておきましょう
```sh
~/mysql-playground/01Beginning$ docker compose run --rm mysql -h mysql80 -e "select @@hostname;"
+--------------+
| @@hostname   |
+--------------+
| 2501ad079d72 |
+--------------+

~/mysql-playground/01Beginning$ docker compose run --rm mysql -h mysql84 -e "select @
@hostname;"
+--------------+
| @@hostname   |
+--------------+
| 1eeb863bfc59 |
+--------------+
```
### 環境を停止し削除する
一通りの環境への理解が得られたら環境を停止し削除します
```sh
~/mysql-playground/01Beginning$ docker compose stop
[+] Stopping 2/2
 ✔ Container playground-ladder-1   Stopped                                                  0.4s 
 ✔ Container playground-mysql80-1  Stopped                                                  1.3s 

~/mysql-playground/01Beginning$ docker compose rm -f
Going to remove playground-mysql80-1, playground-ladder-1
[+] Removing 2/0
 ✔ Container playground-ladder-1   Removed                                                  0.0s 
 ✔ Container playground-mysql80-1  Removed                                                  0.0s
```

個別に起動したコンテナも削除しておきましょう
```sh
~/mysql-playground/01Beginning$ docker compose ps
NAME                   IMAGE       COMMAND                  SERVICE   CREATED              STATUS              PORTS
playground-mysql84-1   mysql:8.4   "docker-entrypoint.s…"   mysql84   About a minute ago   Up About a minute   3306/tcp, 33060/tcp

~/mysql-playground/01Beginning$ docker compose stop mysql84
[+] Stopping 1/1
 ✔ Container playground-mysql84-1  Stopped                                                  0.9s 

~/mysql-playground/01Beginning$ docker compose rm mysql84
? Going to remove playground-mysql84-1 Yes
[+] Removing 1/0
 ✔ Container playground-mysql84-1  Removed                                                  0.0s
```
