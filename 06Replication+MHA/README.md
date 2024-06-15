# MHA
## なにするだ
MHA 構成と挙動を学びます

[ 概要図 ]

各コンテナのパスワードは **なし** で作ってますです  

### 起動するやつリスト 
| service | hostname  | image   | profile | note                |
| ------- | --------- | ------- | ------- | ------------------- |
| node1   | node1     | 57node  |         | server-id=1 master  |
| node2   | node2     | 57node  |         | server-id=2 standby |
| node3   | node3     | 57node  |         | server-id=3 slave   |
| manager | manager   | manager |         |                     |
| ladder  | ladder    | ladder  |         | sshd                |
| mysql   | (dynamic) | ladder  | extra   |                     |

※`profile` が `extra` になっているものは自動起動しません  
※`node1` ~ `node3` は `docker-compose.yml` に依ります。デフォルトは MySQL 8.0 にしています


## 準備
```sh
$ docker compose exec -it node1 bash

[root@node1 /]# echo "server-id=1" >> /etc/my.cnf
[root@node1 /]# echo "log_bin" >> /etc/my.cnf
[root@node1 /]# systemctl start mysqld

```

## シナリオ
 * [mhaって](./scenario01/README.md)