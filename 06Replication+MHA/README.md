# MHA
## なにするだ
MHA 構成と挙動を学びます

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
各コンテナのパスワードは **なし** で作ってますです  

### 起動するやつリスト 
| service | hostname  | image         | profile | topology     | note           |
| ------- | --------- | ------------- | ------- | ------------ | -------------- |
| node1   | node1     | local/57node  |         | master       | server-id=1    |
| node2   | node2     | local/57node  |         | slave-master | server-id=2    |
| node3   | node3     | local/57node  |         | slave        | server-id=3    |
| manager | manager   | local/manager |         |              | mha manager    |
| ladder  | ladder    | local/ladder  |         |              | sshd           |
| mysql   | (dynamic) | local/ladder  | extra   |              |                |
| mysqlsh | (dynamic) | local/mysqlsh | extra   |              |                |
| initer  | (dynamic) | local/ladder  |         |              | for initialize |

※`profile` が `extra` になっているものは自動起動しません  
※`node1` ~ `node3` は `docker-compose.yml` に依ります。デフォルトは MySQL 5.7 にしています


## MHAのトポロジ
```sh
  ┌── MHA ─────────────────────┐                 
  │                            │                 
  │  ┌── HA ─────────────────┐ │                 
  │  │                       │ │                 
  │  │ ┌───────┐   ┌───────┐ │ │     ┌─────────┐ 
  │  │ │ node1 ├──►│ node2 │ │ │◄────┤ manager │ 
  │  │ │ master│   │ slave │ │ │     │         │ 
  │  │ └───┬───┘   └───────┘ │ │     └─────────┘ 
  │  │     │                 │ │                 
  │  └─────┼─────────────────┘ │      // node1 は現マスタ
  │        │                   │      // node2 はスレーブでマスタ候補
  │        │       ┌───────┐   │      // node3 はスレーブ
  │        └──────►│ node3 │   │      // manager は各ノードへ SSH, mysql で接続する
  │                │ slave │   │                 
  │                └───────┘   │                 
  │                            │                 
  └────────────────────────────┘                 
```



## シナリオ
 * [mhaって](./scenario01/README.md)