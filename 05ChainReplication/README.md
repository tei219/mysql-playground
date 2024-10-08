# Chain Replication
## なにするだ
MySQL のチェーンレプリケーションと挙動を学びます

```sh
 ┌─ docker compose ──────────────────────────────────────────────────────┐ 
 │                                                                       │ 
 │                                                                       │ 
 │  ─────┬───────┬───────┬─────────┬───────────┬─────────┬─────────┬──── │ 
 │       │       │       │         │           │         │         │     │ 
 │   ┌───┴──┐ ┌──┴──┐ ┌──┴────┐ ┌──┴───┐   ┌───┴───┐ ┌───┴───┐ ┌───┴───┐ │ 
 │   │ladder│ │mysql│ │mysqlsh│ │initer│   │ node1 │ │ node2 │ │ node3 │ │ 
 │   │      │ │extra│ │extra  │ │      │   │       │ │       │ │       │ │ 
 │   └──*───┘ └─────┘ └───────┘ └──────┘   └───────┘ └───────┘ └───────┘ │ 
 │      22                                                               │ 
 │      ▲                                                                │ 
 │      │                                                                │ 
 └──────*────────────────────────────────────────────────────────────────┘ 
       some                                                                
```

### 起動するやつリスト 
| service | hostname  | image         | profile | topology     | note         |
| ------- | --------- | ------------- | ------- | ------------ | ------------ |
| node1   | node1     | mysql:8.0     |         | master       | server-id=1  |
| node2   | node2     | mysql:8.0     |         | slave-master | server-id=2  |
| node3   | node3     | mysql:8.0     |         | slave        | server-id=3  |
| ladder  | ladder    | local/ladder  |         |              | sshd         |
| mysql   | (dynamic) | local/ladder  | extra   |              | mysql-client |
| mysqlsh | (dynamic) | local/mysqlsh | extra   |              | mysqlsh      |
| initer  | (dynamic) | local/ladder  |         |              | 初期化用     |

※MySQLのバージョンは `docker-compose.yml` に依ります。デフォルトは MySQL 8.0 にしています
※レプリケーションは **ポジションベース** なレプリケーションです  

## シナリオ
 * [データ連携をする](./scenario01/README.md)

## 既知のバグ
## References
* https://dev.mysql.com/doc/refman/8.0/ja/replication.html