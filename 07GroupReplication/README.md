# 500 Group Replication

## なにするだ
デフォルトイメージは MySQL 8.0 にしています  
MySQL 5.6 以下では機能がないので Group Replication は組めまへん  

### 起動するやつリスト
| service | hostname  | image         | profile | note                   |
| ------- | --------- | ------------- | ------- | ---------------------- |
| node1   | (dynamic) | mysql:8.0     |         | パスなし               |
| node2   | (dynamic) | mysql:8.0     |         | パスなし               |
| node3   | (dynamic) | mysql:8.0     |         | パスなし               |
| ladder  | (dynamic) | ladder:latest |         | パスなし sshd          |
| mysql   | (dynamic) | ladder:latest | extra   |                        |
| mysqlsh | (dynamic) | ubuntu        | extra   |                        |
| initer  | (dynamic) | ladder:latest |         | 初期化スクリプト実行用 |


## シナリオ
1. [Group Replication の確認](./scenario01/README.md)
2. HA発生
3. わわわ


## やってみよう

### 確認
シングルマスタだよ  

### 外れたで再ジョイン
### リストアで再ジョイン
### マスタ切り替え
### ノード追加
### ノード削除



=============================


## docker compose up -d 
## docker compose run --rm mysql -h node1 -e "$(cat grstatus.sql)"

# scenario
## down -> start group_replication
## (updating) down -> reset master , change master, start group_replication -> fail
## (updating) down -> data recovery -> reset master , change master, start group_replication