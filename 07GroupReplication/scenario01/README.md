# Group Replication の確認 <!-- omit in toc -->
- [起動と確認](#起動と確認)
- [おっと再起動だ](#おっと再起動だ)

## やってみよう <!-- omit in toc -->

### 起動と確認
環境を起動してGroup Replication状況を確認しましょう
```sh
~/mysql-playground/07GroupReplication$ docker compose up -d
[+] Running 5/5
 ✔ Container gr80-node1-1   Healthy                                                         6.7s 
 ✔ Container gr80-ladder-1  Started                                                         0.5s 
 ✔ Container gr80-node2-1   Healthy                                                        11.2s 
 ✔ Container gr80-node3-1   Healthy                                                        11.7s 
 ✔ Container gr80-initer-1  Started                                                        12.0s
```

起動できたら、下のテーブルを参照してGroupReplicationの状態を確認してみましょう
* performance_schema.replication_group_member_stats テーブル
```sql
mysql> select * from performance_schema.replication_group_member_stats;
```
```sh
~/mysql-playground/07GroupReplication$ docker compose run --rm mysql \
-h node1 -e "select * from performance_schema.replication_group_member_stats \G"
*************************** 1. row ***************************
                              CHANNEL_NAME: group_replication_applier
                                   VIEW_ID: 17200693321741243:3
                                 MEMBER_ID: 8bea3b83-39c2-11ef-a51a-0242ac140003
               COUNT_TRANSACTIONS_IN_QUEUE: 0
                COUNT_TRANSACTIONS_CHECKED: 0
                  COUNT_CONFLICTS_DETECTED: 0
        COUNT_TRANSACTIONS_ROWS_VALIDATING: 0
        TRANSACTIONS_COMMITTED_ALL_MEMBERS: 8bea3b83-39c2-11ef-a51a-0242ac140003:1-5,
aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee:1-3
            LAST_CONFLICT_FREE_TRANSACTION: 
COUNT_TRANSACTIONS_REMOTE_IN_APPLIER_QUEUE: 0
         COUNT_TRANSACTIONS_REMOTE_APPLIED: 3
         COUNT_TRANSACTIONS_LOCAL_PROPOSED: 0
         COUNT_TRANSACTIONS_LOCAL_ROLLBACK: 0
*************************** 2. row ***************************
                              CHANNEL_NAME: group_replication_applier
                                   VIEW_ID: 17200693321741243:3
                                 MEMBER_ID: 8f588bd8-39c2-11ef-a65d-0242ac140004
               COUNT_TRANSACTIONS_IN_QUEUE: 0
                COUNT_TRANSACTIONS_CHECKED: 0
                  COUNT_CONFLICTS_DETECTED: 0
        COUNT_TRANSACTIONS_ROWS_VALIDATING: 0
        TRANSACTIONS_COMMITTED_ALL_MEMBERS: 8bea3b83-39c2-11ef-a51a-0242ac140003:1-5,
aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee:1-3
            LAST_CONFLICT_FREE_TRANSACTION: 
COUNT_TRANSACTIONS_REMOTE_IN_APPLIER_QUEUE: 0
         COUNT_TRANSACTIONS_REMOTE_APPLIED: 1
         COUNT_TRANSACTIONS_LOCAL_PROPOSED: 0
         COUNT_TRANSACTIONS_LOCAL_ROLLBACK: 0
*************************** 3. row ***************************
                              CHANNEL_NAME: group_replication_applier
                                   VIEW_ID: 17200693321741243:3
                                 MEMBER_ID: 8f634019-39c2-11ef-a668-0242ac140005
               COUNT_TRANSACTIONS_IN_QUEUE: 0
                COUNT_TRANSACTIONS_CHECKED: 0
                  COUNT_CONFLICTS_DETECTED: 0
        COUNT_TRANSACTIONS_ROWS_VALIDATING: 0
        TRANSACTIONS_COMMITTED_ALL_MEMBERS: 8bea3b83-39c2-11ef-a51a-0242ac140003:1-5,
aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee:1-3
            LAST_CONFLICT_FREE_TRANSACTION: 
COUNT_TRANSACTIONS_REMOTE_IN_APPLIER_QUEUE: 0
         COUNT_TRANSACTIONS_REMOTE_APPLIED: 0
         COUNT_TRANSACTIONS_LOCAL_PROPOSED: 0
         COUNT_TRANSACTIONS_LOCAL_ROLLBACK: 0

```
`MEMBER_ID` はサーバ一意の値に設定されます
`TRANSACTIONS_COMMITTED_ALL_MEMBERS` はマスタの `MEMBER_ID` を利用して設定されます ＝ コミットされたマスタのバイナリログのポジションを示します


* performance_schema.replication_group_members テーブル
```sql
mysql> select * from performance_schema.replication_group_members;
```
```sh
~/mysql-playground/07GroupReplication$ docker compose run --rm mysql \
-h node1 -e "select * from performance_schema.replication_group_members \G"
*************************** 1. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8bea3b83-39c2-11ef-a51a-0242ac140003
               MEMBER_HOST: node1
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: PRIMARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
*************************** 2. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8f588bd8-39c2-11ef-a65d-0242ac140004
               MEMBER_HOST: node2
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: SECONDARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
*************************** 3. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8f634019-39c2-11ef-a668-0242ac140005
               MEMBER_HOST: node3
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: SECONDARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
```
`MEMBER_STATE` はノードの状態を示しています  
`MEMBER_ROLE` はノードの役割を示しています。今回の環境はシングルマスタ構成になっているので、`PRIMARY` のマスタが１つ、他の２つが `SECONDARY` のメンバになっています

### おっと再起動だ
ここでマスタの`node1`を停止して確認してみましょう
```sh
~/mysql-playground/07GroupReplication$ docker compose stop node1
[+] Stopping 1/1
 ✔ Container gr80-node1-1  Stopped  
```

`node1` 以外のノードが `PRIMARY` になっていることがわかります  
※クエリの実行先は`node2`とかにしましょう
```sh
~/mysql-playground/07GroupReplication$ docker compose run --rm mysql \
 -h node2 -e "select * from performance_schema.replication_group_members \G"
*************************** 1. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8f588bd8-39c2-11ef-a65d-0242ac140004
               MEMBER_HOST: node2
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: PRIMARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
*************************** 2. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8f634019-39c2-11ef-a668-0242ac140005
               MEMBER_HOST: node3
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: SECONDARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
```

`node1` が再度起動すると
```sh
~/mysql-playground/07GroupReplication$ docker compose up -d node1
[+] Running 1/1
 ✔ Container gr80-node1-1  Started                                                                  0.2s
```
```sh
~/mysql-playground/07GroupReplication$ docker compose run --rm mysql \
 -h node2 -e "select * from performance_schema.replication_group_members \G"
*************************** 1. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8f588bd8-39c2-11ef-a65d-0242ac140004
               MEMBER_HOST: node2
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: PRIMARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
*************************** 2. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8f634019-39c2-11ef-a668-0242ac140005
               MEMBER_HOST: node3
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: SECONDARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
```
自動で復帰しないことがわかります  
これは `group-replication-start-on-boot=off` パラメータが原因です  
`node1`をメンバに復帰させるには下記対応が必要です。やってみましょう
```sql
mysql> start group_replication;
```
```sh
~/mysql-playground/07GroupReplication$ docker compose run --rm mysql \
 -h node1 -se "start group_replication;"

~/mysql-playground/07GroupReplication$ docker compose run --rm mysql \
 -h node2 -e "select * from performance_schema.replication_group_members \G"
*************************** 1. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8bea3b83-39c2-11ef-a51a-0242ac140003
               MEMBER_HOST: node1
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: SECONDARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
*************************** 2. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8f588bd8-39c2-11ef-a65d-0242ac140004
               MEMBER_HOST: node2
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: PRIMARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
*************************** 3. row ***************************
              CHANNEL_NAME: group_replication_applier
                 MEMBER_ID: 8f634019-39c2-11ef-a668-0242ac140005
               MEMBER_HOST: node3
               MEMBER_PORT: 3306
              MEMBER_STATE: ONLINE
               MEMBER_ROLE: SECONDARY
            MEMBER_VERSION: 8.0.38
MEMBER_COMMUNICATION_STACK: XCom
```

3ノードとも `MEMBER_STATE` が `ONLINE` になっていることが確認できました  
`SECONDARY` で発生した場合も同様に起動後に`start group_replication;`を実行すれば復帰します（マスタの移行は発生しない）  

# Reference <!-- omit in toc -->
* https://dev.mysql.com/doc/refman/8.0/ja/group-replication-monitoring.html