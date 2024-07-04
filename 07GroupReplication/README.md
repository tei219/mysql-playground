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
| service | hostname  | image         | profile | topology | note           |
| ------- | --------- | ------------- | ------- | -------- | -------------- |
| node1   | node1     | mysql:8.0     |         | master   | server-id=1    |
| node2   | node2     | mysql:8.0     |         | slave    | server-id=2    |
| node3   | node3     | mysql:8.0     |         | slave    | server-id=3    |
| ladder  | ladder    | local/ladder  |         |          | sshd           |
| mysql   | (dynamic) | local/ladder  | extra   |          |                |
| mysqlsh | (dynamic) | local/mysqlsh | extra   |          |                |
| initer  | (dynamic) | local/ladder  |         |          | for initialize |


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
1. [Group Replication の確認](./scenario01/README.md)
2. HA発生
3. わわわ

## 既知のバグ
## References
* https://dev.mysql.com/doc/refman/8.0/ja/group-replication.html
* https://dev.mysql.com/doc/refman/8.0/ja/mysql-shell-userguide.html
  
=============================

### 確認
シングルマスタだよ  

### 外れたで再ジョイン
### リストアで再ジョイン
### マスタ切り替え
### ノード追加
### ノード削除


## docker compose up -d 
## docker compose run --rm mysql -h node1 -e "$(cat grstatus.sql)"

# scenario
## down -> start group_replication
## (updating) down -> reset master , change master, start group_replication -> fail
## (updating) down -> data recovery -> reset master , change master, start group_replication