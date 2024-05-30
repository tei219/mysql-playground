# mysql-playground
## なにこれ
MySQL の使い方を学ぶことを目的とした MySQL でゴニョゴニョするプレイグラウンドです。  
Docker compose を利用した環境セットになっているので Docker 環境があればすぐに利用できます。  

## 使い方
### 必要環境
`docker` 及び `docker compose` が使える環境が必要です。  
下記バージョンで確認しています。  

```sh
$ docker version
Client: Docker Engine - Community
 Version:           26.1.2
 API version:       1.45
 Go version:        go1.21.10
 Git commit:        211e74b
 Built:             Wed May  8 13:59:59 2024
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          26.1.2
  API version:      1.45 (minimum version 1.24)
  Go version:       go1.21.10
  Git commit:       ef1912d
  Built:            Wed May  8 13:59:59 2024
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.31
  GitCommit:        e377cd56a71523140ca6ae87e30244719194a521
 runc:
  Version:          1.1.12
  GitCommit:        v1.1.12-0-g51d5e94
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
  ```

### 利用時
プレイグラウンドを利用する際は、各シナリオ（ディレクトリ）にある個別の Readme を参照してください。

### 起動
基本的に `docker compose` でシナリオに必要な環境が起動します。  
```sh
$ docker compose up -d
```

### 停止
使用後は環境を停止します。  
データの有無で挙動が変わる場合があるので、必要がなければ停止後に削除してください。
```sh
$ docker compose stop
$ docker compose rm -f
```

## 使用例
```sh
$ cd 000

--起動
$ docker compose up -d
[+] Running 2/2
 ✔ Container 000-mysql80-1 Started  0.3s 
 ✔ Container 000-ladder-1  Started  0.4s

--コンテナ確認
$ docker compose ps
NAME            IMAGE        COMMAND                  SERVICE   CREATED         STATUS         PORTS
000-ladder-1    000-ladder   "/usr/sbin/sshd -D"      ladder    2 minutes ago   Up 2 minutes   0.0.0.0:32769->22/tcp, :::32769->22/tcp
000-mysql80-1   mysql:8.0    "docker-entrypoint.s…"   mysql80   2 minutes ago   Up 2 minutes   3306/tcp, 33060/tcp

--mysql 発行
$ docker compose run --rm mysql -h mysql80 -e "select @@version"
+-----------+
| @@version |
+-----------+
| 8.0.37    |
+-----------+

--停止
$ docker compose stop
[+] Stopping 2/2
 ✔ Container 000-ladder-1   Stopped  0.4s
 ✔ Container 000-mysql80-1  Stopped  1.3s

 --破棄
 $ docker compose rm -f
Going to remove 000-ladder-1, 000-mysql80-1
[+] Removing 2/0
 ✔ Container 000-mysql80-1  Removed  0.0s
 ✔ Container 000-ladder-1   Removed  0.0s
 ```

## 既知のバグ
