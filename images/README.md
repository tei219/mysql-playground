# images
## `ladder`
`sshd` のコンテナイメージです。各シナリオ環境への踏み台として起動します  
下記にあるようにいくつかの用途にも使えるように作成しています  


### ladder as `mysql`
`mysql-client` のコンテナイメージとして エンドポイントを `/usr/bin/mysql` に指定して利用します

### ladder as `initer`
環境構築用バッチを起動する `bash` のコンテナイメージとして エンドポイントを `/initer-entrypoint.sh` に指定して利用します  
`/initer.d` をボリュームマッピングして 数字順でソートされたバッチ を実行します 

<details>
<summary>数字順でソートされたバッチ</summary>

```sh
$ grep . initer.d/*
initer.d/00.echo.sh:echo "Hello, everyone"
initer.d/10.date.sh:date
initer.d/15.hostname.sh:hostname
initer.d/90.ip.sh:ip a

--エントリーポイント指定して起動
$ docker run --rm -v "./initer.d:/initer.d" --entrypoint /initer-entrypoint.sh initer 
Hello, everyone
Thu May 30 09:44:14 UTC 2024
9af9e47db89f
1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN qlen 1000
    link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
    inet 127.0.0.1/8 scope host lo
       valid_lft forever preferred_lft forever
    inet6 ::1/128 scope host 
       valid_lft forever preferred_lft forever
30: eth0@if31: <BROADCAST,MULTICAST,UP,LOWER_UP,M-DOWN> mtu 1500 qdisc noqueue state UP 
    link/ether 02:42:ac:11:00:02 brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.2/16 brd 172.17.255.255 scope global eth0
       valid_lft forever preferred_lft forever
```
</details>

## `mysqlsh`
`mysql-shell (mysqlsh)` のコンテナイメージです  
とりあえず最新版が降ってきます。バージョン指定の要望があれば言ってください  
(ladder に統合したい)

## `os/*`
`upstart` もしくは `systemd` が起動するようにしたコンテナイメージです  
デフォルトで `/sbin/init` が入ってるものはそのまま利用しています  

## `mha/57node`
MHA 環境用 MySQL 5.7 のコンテナイメージです  
centos:7 ベース、systemd を利用しています

## `mha/manager`
MHA 環境用 mha manager のコンテナイメージです  
centos:7 ベース、systemd を利用しています
