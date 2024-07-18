LBでやったほうが無難かも

# Group Replication となにかしら Proxy/LB
## なにするだ
Group Replication 利用時にマスタとスレーブに振り分ける機構を用意して挙動を確認します  
```sh
 ┌─ docker compose ──────────────────────────────────────────────────────┐ 
 │                                                                       │ 
 │                                                                       │ 
 │  ─────┬───────┬───────┬─────────┬─────┬─────┬─────────┬─────────┬──── │ 
 │       │       │       │         │     │     │         │         │     │ 
 │   ┌───┴──┐ ┌──┴──┐ ┌──┴────┐ ┌──┴───┐ │ ┌───┴───┐ ┌───┴───┐ ┌───┴───┐ │ 
 │   │ladder│ │mysql│ │mysqlsh│ │initer│ │ │ node1 │ │ node2 │ │ node3 │ │ 
 │   │      │ │extra│ │extra  │ │      │ │ │       │ │       │ │       │ │ 
 │   └──*───┘ └─────┘ └───────┘ └──────┘ │ └───────┘ └───────┘ └───────┘ │ 
 │      22                               │                               │ 
 │      ▲                                │                               │ 
 │      │                            ┌───┴─────┐                         │ 
 │      │                            │ haproxy │                         │ 
 │      │                            │         │                         │ 
 │      │                            └─────────┘                         │ 
 └──────*────────────────────────────────────────────────────────────────┘ 
       some                                                                
```

### 起動するやつリスト
| service | hostname  | image         | profile | topology | note         |
| ------- | --------- | ------------- | ------- | -------- | ------------ |
| node1   | node1     | mysql:8.0     |         | master   | server-id=1  |
| node2   | node2     | mysql:8.0     |         | slave    | server-id=2  |
| node3   | node3     | mysql:8.0     |         | slave    | server-id=3  |
| haproxy | haproxy   | local/ladder  |         |          | haproxy      |
| ladder  | ladder    | local/ladder  |         |          | sshd         |
| mysql   | (dynamic) | local/ladder  | extra   |          | mysql-client |
| mysqlsh | (dynamic) | local/mysqlsh | extra   |          | mysqlsh      |
| initer  | (dynamic) | local/ladder  |         |          | 初期化用     |
※MySQLのバージョンは `docker-compose.yml` に依ります。デフォルトは MySQL 8.0 にしています

## Group Replication のトポロジ
```sh
                                                                      
                           ┌──────────────┐                           
                           │              │                           
                           │              │                           
  ┌─── GR ─────────────────┴──────┐       │ mysql_readonly_backend    
  │                        ▼      │       │                           
  │ ┌────────────┐  ┌───────────┐ │       │                           
  │ │            │  │           │ │       │                           
  │ │ ┌───────┐  │  │ ┌───────┐ │ │       │                           
  │ │ │ node1 │◄─┼──┤►│ node2 │ │ │       │                           
  │ │ │ master│  │  │ │ slave │ │ │  ┌────┴───────────────────┐       
  │ │ └───────┘  │  │ └───────┘ │ │  │                        │       
  │ │       ▲    │  │      ▲    │ │  │ haproxy                │       
  │ │       │    │  │      │    │ │  │                        │       
  │ │       │    │  │      ▼    │ │  │    mysql_readonly 3308 *       
  │ │       │    │  │ ┌───────┐ │ │  │                        │       
  │ │       └────┼──┤►│ node3 │ │ │  │    mysql_write    3307 *       
  │ │            │  │ │ slave │ │ │  │                        │       
  │ │            │  │ └───────┘ │ │  └────┬───────────────────┘       
  │ │            │  │           │ │       │                           
  │ └────────────┘  └───────────┘ │       │                           
  │       ▲                       │       │                           
  └───────┬───────────────────────┘       │                           
          │                               │                           
          └───────────────────────────────┘                           
                 mysql_write_backend                                  
                                                                      
                                
```
## シナリオ

```
:~/mysql-playground/08GroupReplication+Router$ docker compose logs haproxy
haproxy-1  | [NOTICE]   (1) : haproxy version is 2.8.10-f28885f
haproxy-1  | [WARNING]  (1) : config : Proxy 'mysql_write_backend' : 'insecure-fork-wanted' not enabled in the global section, 'option external-check' will likely fail.
haproxy-1  | [WARNING]  (1) : config : Proxy 'mysql_readonly_backend' : 'insecure-fork-wanted' not enabled in the global section, 'option external-check' will likely fail.
haproxy-1  | [WARNING]  (1) : Server mysql_write_backend/node2 is DOWN, reason: External check error, code: 1, check duration: 18ms. 2 active and 0 backup servers left. 0 sessions active, 0 requeued, 0 remaining in queue.
haproxy-1  | [WARNING]  (1) : Server mysql_write_backend/node3 is DOWN, reason: External check error, code: 1, check duration: 19ms. 1 active and 0 backup servers left. 0 sessions active, 0 requeued, 0 remaining in queue.
haproxy-1  | [WARNING]  (1) : Server mysql_readonly_backend/node1 is DOWN, reason: External check error, code: 1, check duration: 20ms. 2 active and 0 backup servers left. 0 sessions active, 0 requeued, 0 remaining in queue.
```

## 既知のバグ
## References
* https://dev.mysql.com/doc/refman/8.0/ja/group-replication.html