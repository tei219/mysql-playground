# Group Replication
## なにするだ
Group Replication の構成と挙動について学びます  
MySQL 5.6 以下では機能がないので Group Replication は組めまへん  

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
| service | hostname  | image         | profile | topology | note         |
| ------- | --------- | ------------- | ------- | -------- | ------------ |
| node1   | node1     | mysql:8.0     |         | master   | server-id=1  |
| node2   | node2     | mysql:8.0     |         | slave    | server-id=2  |
| node3   | node3     | mysql:8.0     |         | slave    | server-id=3  |
| ladder  | ladder    | local/ladder  |         |          | sshd         |
| mysql   | (dynamic) | local/ladder  | extra   |          | mysql-client |
| mysqlsh | (dynamic) | local/mysqlsh | extra   |          | mysqlsh      |
| initer  | (dynamic) | local/ladder  |         |          | 初期化用     |

※MySQLのバージョンは `docker-compose.yml` に依ります。デフォルトは MySQL 8.0 にしています

## Group Replication のトポロジ
```sh
 ┌── GR ──────────────────────┐ 
 │                            │ 
 │  ┌───────┐     ┌───────┐   │ 
 │  │ node1 │◄───►│ node2 │   │ 
 │  │ master│     │ slave │   │ 
 │  └───────┘     └───────┘   │ 
 │        ▲            ▲      │ 
 │        │            │      │ 
 │        │            ▼      │ 
 │        │       ┌───────┐   │ 
 │        └──────►│ node3 │   │ 
 │                │ slave │   │ 
 │                └───────┘   │ 
 │                            │ 
 └────────────────────────────┘ 
                                
```
取り急ぎ シングルマスタ 構成です  


## シナリオ
1. [GroupReplicationの確認](./scenario01/README.md)
2. [GroupReplicationのリカバリ](./scenario02/README.md)
3. [GroupReplicationのリカバリ２](./scenario03/README.md)
4. マスタ切り替え
5. ノード追加
6. ノード削除

## 既知のバグ
起動のタイミングによっては initer による初期化が失敗する場合があります  
メンバノードのステータスが`ONLINE`になっていない場合は下記コマンドで再度初期化を実施してみてください  
```sh
~/mysql-playground/07GroupReplication$ docker compose rm initer
~/mysql-playground/07GroupReplication$ docker compose up initer
```

## References
* https://dev.mysql.com/doc/refman/8.0/ja/group-replication.html
* https://dev.mysql.com/doc/refman/8.0/ja/mysql-shell-userguide.html