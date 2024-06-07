# Chain Replication
## なにするだ
MySQL のチェーンレプリケーションと挙動を学びます

[ 概要図 ]

各コンテナのパスワードは **なし** で作ってますです  

### 起動するやつリスト 
| service | hostname  | image       | profile | note                     |
| ------- | --------- | ----------- | ------- | ------------------------ |
| node1   | node1     | (mysql:8.0) |         | server-id=1 master       |
| node2   | node2     | (mysql:8.0) |         | server-id=2 slave-master |
| node3   | node3     | (mysql:8.0) |         | server-id=3 slave        |
| ladder  | ladder    | ladder      |         | sshd                     |
| mysql   | (dynamic) | ladder      | extra   |                          |
| mysqlsh | (dynamic) | mysqlsh     | extra   |                          |

※`profile` が `extra` になっているものは自動起動しません  
※`node1` ~ `node3` は `docker-compose.yml` に依ります。デフォルトは MySQL 8.0 にしています

## シナリオ
 * [データ連携をする](./scenario01/README.md)