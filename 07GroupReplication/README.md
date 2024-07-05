# Group Replication
## なにするだ
デフォルトイメージは MySQL 8.0 にしています  
MySQL 5.6 以下では機能がないので Group Replication は組めまへん  

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
 │      │                            │ manager │                         │ 
 │      │                            │         │                         │ 
 │      │                            └─────────┘                         │ 
 └──────*────────────────────────────────────────────────────────────────┘ 
       some                                                                
```

### 起動するやつリスト
| service | hostname  | image         | profile | topology | note        |
| ------- | --------- | ------------- | ------- | -------- | ----------- |
| node1   | node1     | mysql:8.0     |         | master   | server-id=1 |
| node2   | node2     | mysql:8.0     |         | slave    | server-id=2 |
| node3   | node3     | mysql:8.0     |         | slave    | server-id=3 |
| ladder  | ladder    | local/ladder  |         |          | sshd        |
| mysql   | (dynamic) | local/ladder  | extra   |          |             |
| mysqlsh | (dynamic) | local/mysqlsh | extra   |          |             |
| initer  | (dynamic) | local/ladder  |         |          | 初期化用    |


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

## 既知のバグ
起動のタイミングによっては initer による初期化が失敗する場合があります  
メンバのノードが`ONLINE`になっていない場合は下記コマンドで再度初期化を実施してみてください  
```sh
~/mysql-playground/07GroupReplication$ docker compose rm initer
~/mysql-playground/07GroupReplication$ docker compose up initer
```

## References
* https://dev.mysql.com/doc/refman/8.0/ja/group-replication.html
* https://dev.mysql.com/doc/refman/8.0/ja/mysql-shell-userguide.html
  



### リストアで再ジョイン
### マスタ切り替え
### ノード追加
### ノード削除

# scenario
## (updating) down -> reset master , start group_replication -> fail 
## (updating) down -> data recovery : clone, start group_replication
###   data recovery : mysqldump, filecopy -> reset master? , change master?, start group_replication
