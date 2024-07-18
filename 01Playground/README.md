# Playground
## なにするだ
プレイグラウンド環境を理解します。環境の概要は下記のとおりです

```sh
                                                                                                
┌─ docker compose ────────────────────────────────────────────────────────────────────────────┐ 
│                                                                                             │ 
│                                                                                             │ 
│  ─────┬───────┬─────────┬───────────┬───────────┬───────────┬───────────┬───────────┬─────  │ 
│       │       │         │           │           │           │           │           │       │ 
│   ┌───┴──┐ ┌──┴──┐ ┌────┴────┐ ┌────┴────┐ ┌────┴────┐ ┌────┴────┐ ┌────┴────┐ ┌────┴────┐  │ 
│   │ladder│ │mysql│ │ mysql90 │ │ mysql84 │ │ mysql80 │ │ mysql57 │ │ mysql56 │ │ mysql55 │  │ 
│   │      │ │extra│ │ extra   │ │ extra   │ │         │ │ extra   │ │ extra   │ │ extra   │  │ 
│   └──*───┘ └─────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘ └─────────┘  │ 
│      22                                                                                     │ 
│      ▲                                                                                      │ 
│      │                                                                                      │ 
└──────┴──────────────────────────────────────────────────────────────────────────────────────┘ 
       * 
      some                                                                                              
```
各コンテナは **root/パスなし** で作ってますです  

### 起動するやつリスト 
| service | hostname  | image        | profile | note              |
| ------- | --------- | ------------ | ------- | ----------------- |
| mysql90 | (dynamic) | mysql:9.0    | extra   | パスなし          |
| mysql84 | (dynamic) | mysql:8.4    | extra   | パスなし          |
| mysql80 | (dynamic) | mysql:8.0    |         | パスなし          |
| mysql57 | (dynamic) | mysql:5.7    | extra   | パスなし          |
| mysql56 | (dynamic) | mysql:5.6    | extra   | パスなし          |
| mysql55 | (dynamic) | mysql:5.5    | extra   | パスなし          |
| ladder  | (dynamic) | local/ladder |         | パスなし 踏み台   |
| mysql   | (dynamic) | local/ladder | extra   | mysqlクライアント |

※`profile` が `extra` になっているものは自動起動しません  

## シナリオ
 * [環境を理解する](./scenario01/README.md)
 * [サンプルデータベースを利用する](./scenario02/README.md)

## 既知のバグ

## References
* https://docs.docker.com/engine/
* https://docs.docker.com/compose/
* https://docs.docker.com/compose/profiles/
* https://hub.docker.com/_/mysql