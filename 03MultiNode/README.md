# Multi Node
## なにするだ
MySQL の複数台構成時の挙動やレプリケーションを学びます
```sh
 ┌─ docker compose ──────────────────────────────────────────────────────┐ 
 │                                                                       │ 
 │                                                                       │ 
 │  ─────┬───────┬───────┬─────────────┬─────────┬─────────┬──────────── │ 
 │       │       │       │             │         │         │             │ 
 │   ┌───┴──┐ ┌──┴──┐ ┌──┴────┐    ┌───┴───┐ ┌───┴───┐ ┌───┴───┐         │ 
 │   │ladder│ │mysql│ │mysqlsh│    │ node1 │ │ node2 │ │ node3 │         │ 
 │   │      │ │extra│ │extra  │    │       │ │       │ │       │         │ 
 │   └──*───┘ └─────┘ └───────┘    └───────┘ └───────┘ └───────┘         │ 
 │      22                                                               │ 
 │      ▲                                                                │ 
 │      │                                                                │ 
 └──────*────────────────────────────────────────────────────────────────┘ 
       some                                                                
```
各コンテナのパスワードは **なし** で作ってますです  

### 起動するやつリスト 
| service | hostname  | image         | profile | topology | note        |
| ------- | --------- | ------------- | ------- | -------- | ----------- |
| node1   | node1     | mysql:8.0     |         |          | server-id=1 |
| node2   | node2     | mysql:8.0     |         |          | server-id=2 |
| node3   | node3     | mysql:8.0     |         |          | server-id=3 |
| ladder  | ladder    | local/ladder  |         |          | sshd        |
| mysql   | (dynamic) | local/ladder  | extra   |          |             |
| mysqlsh | (dynamic) | local/mysqlsh | extra   |          |             |

※`node1` ~ `node3` は `docker-compose.yml` に依ります。デフォルトは MySQL 8.0 にしています

## シナリオ
 * [データ連携をする federated](./scenario01/README.md) 代替ストレージエンジン
 * 複製する　バックアップ
 * 複製する　ファイルコピー
 * 複製する　clone

## 既知のバグ

## References
* https://dev.mysql.com/doc/refman/8.0/ja/storage-engines.html
