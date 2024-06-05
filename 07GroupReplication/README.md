# 500 Group Replication

## なにするだ
デフォルトイメージは MySQL 8.0 にしています  
MySQL 5.6 では機能がないので Group Replication は組めません  

### 起動するやつリスト
| service | hostname  | image         | profile | note                   |
| ------- | --------- | ------------- | ------- | ---------------------- |
| node1   | (dynamic) | mysql:8.0     |         | パスなし               |
| node2   | (dynamic) | mysql:8.0     |         | パスなし               |
| node3   | (dynamic) | mysql:8.0     |         | パスなし               |
| ladder  | (dynamic) | ladder:latest |         | パスなし sshd          |
| mysql   | (dynamic) | ladder:latest | extra   |                        |
| mysqlsh | (dynamic) | ladder:latest | extra   |                        |
| initer  | (dynamic) | ladder:latest |         | 初期化スクリプト実行用 |


## 起動


## 停止と削除


## docker compose up -d 
## docker compose run --rm mysql -h node1 -e "$(cat grstatus.sql)"

# scenario
## down -> start group_replication
## (updating) down -> reset master , change master, start group_replication -> fail
## (updating) down -> data recovery -> reset master , change master, start group_replication