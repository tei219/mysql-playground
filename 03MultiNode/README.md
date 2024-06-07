# Multi Node
## なにするだ
MySQL の複数台構成時の挙動やレプリケーションを学びます

[ 概要図 ]

各コンテナのパスワードは **なし** で作ってますです  

### 起動するやつリスト 
| service | hostname  | image       | profile | note        |
| ------- | --------- | ----------- | ------- | ----------- |
| node1   | node1     | (mysql:8.0) |         | server-id=1 |
| node2   | node2     | (mysql:8.0) |         | server-id=2 |
| node3   | node3     | (mysql:8.0) | extra   | server-id=3 |
| ladder  | ladder    | ladder      |         | sshd        |
| mysql   | (dynamic) | ladder      | extra   |             |
| mysqlsh | (dynamic) | mysqlsh     | extra   |             |

※`profile` が `extra` になっているものは自動起動しません  
※`node1` ~ `node3` は `docker-compose.yml` に依ります。デフォルトは MySQL 8.0 にしています

## シナリオ
 * [データ連携をする](./scenario01/README.md)