# mysql-playground
## なにこれ
MySQL の使い方を学ぶことを目的とした MySQL でゴニョゴニョするプレイグラウンドです  
Docker compose を利用した環境セットになっているので Docker 環境があればすぐに利用できます  

## 使い方
### 必要環境
`docker` 及び `docker compose` が使える環境が必要です  
下記バージョンで確認しています  

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
```sh
$ docker info
Client: Docker Engine - Community
 Version:    26.1.2
 Context:    default
 Debug Mode: false
 Plugins:
  buildx: Docker Buildx (Docker Inc.)
    Version:  v0.14.0
    Path:     /usr/libexec/docker/cli-plugins/docker-buildx
  compose: Docker Compose (Docker Inc.)
    Version:  v2.27.0
    Path:     /usr/libexec/docker/cli-plugins/docker-compose

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 9
 Server Version: 26.1.2
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Using metacopy: false
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: e377cd56a71523140ca6ae87e30244719194a521
 runc version: v1.1.12-0-g51d5e94
 init version: de40ad0
 Security Options:
  seccomp
   Profile: builtin
 Kernel Version: 5.15.146.1-microsoft-standard-WSL2
 Operating System: Ubuntu 22.04.4 LTS
 OSType: linux
 Architecture: x86_64
 CPUs: 16
 Total Memory: 31.26GiB
 Name: GUINESS
 ID: e346446a-14a0-4367-b00f-f98dcd0a78af
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Experimental: false
 Insecure Registries:
  127.0.0.0/8
 Live Restore Enabled: false

WARNING: No blkio throttle.read_bps_device support
WARNING: No blkio throttle.write_bps_device support
WARNING: No blkio throttle.read_iops_device support
WARNING: No blkio throttle.write_iops_device support
  ```

### 利用時
プレイグラウンドを利用する際は、各シナリオ（ディレクトリ）にある個別の Readme を参照してください

### 起動
下記コマンドでシナリオに必要な環境が起動します  
```sh
$ docker compose up -d
```

### 停止
使用後は環境を停止します  
データの有無で挙動が変わる場合があるので、必要がなければ停止後に削除してください
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

--ladder にログイン
$ ssh localhost -l root -o StrictHostKeyChecking=no -p 32769

--ladder で mysql 発行
96dbb631d46a:~# mysql -h mysql80 -e "select @@hostname;"
+--------------+
| @@hostname   |
+--------------+
| 6cf789da7364 |
+--------------+

96dbb631d46a:~# 
96dbb631d46a:~# exit
logout
Connection to localhost closed.

--ホストから mysql 発行
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

## 注意事項
 * **Failed to get D-Bus connection: No such file or directory**  
`systemd` を利用するコンテナで発生する上記エラーは dockerホスト の `Cgroup Version` に起因します  
`v2` のホストで `v1` のイメージは起動できず上記エラーがでます  
ホストの version 確認は `$ stat -fc %T /sys/fs/cgroup/` の結果が `tmpfs` なら `v1`、`cgroup2fs` なら`v2` で確認できます（2敗）  

## 既知のバグ
