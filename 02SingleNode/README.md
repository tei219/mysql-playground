# Single Node
## なにするだ
MySQL の単体構成時の挙動やバージョン間での差異について学びます

```sh
┌─ docker compose ──────────────────────────────────────────────────────┐
│                                                                       │
│                                                                       │
│  ─────┬───────┬───────┬─────────────┬──────────────────────────────── │
│       │       │       │             │                                 │
│   ┌───┴──┐ ┌──┴──┐ ┌──┴────┐    ┌───┴───┐                             │
│   │ladder│ │mysql│ │mysqlsh│    │ node1 │                             │
│   │      │ │extra│ │extra  │    │       │                             │
│   └──*───┘ └─────┘ └───────┘    └───────┘                             │
│      22                                                               │
│      ▲                                                                │
│      │                                                                │
└──────*────────────────────────────────────────────────────────────────┘
      some                                                               
``` 

### 起動するやつリスト 
| service | hostname  | image        | profile | note         |
| ------- | --------- | ------------ | ------- | ------------ |
| node1   | node1     | mysql:8.0    |         |              |
| ladder  | ladder    | local/ladder |         | sshd         |
| mysql   | (dynamic) | local/ladder | extra   | mysql-client |

※MySQLのバージョンは `docker-compose.yml` に依ります。デフォルトは MySQL 8.0 にしています

## シナリオ
* [MySQLを理解する](./scenario01/README.md)
* セキュリティー
* バックアップとリカバリ
* SQLステートメントと最適化と言語構造
* 関数と演算子
* 文字セットと照合順序とデータ型
* ストレージエンジン
* バージョン間の違いを確認する
* https://dev.mysql.com/doc/refman/8.0/ja/partitioning.html
* https://dev.mysql.com/doc/refman/8.0/ja/stored-objects.html
* https://dev.mysql.com/doc/refman/8.0/ja/information-schema.html
* https://dev.mysql.com/doc/refman/8.0/ja/performance-schema.html
* https://dev.mysql.com/doc/refman/8.0/ja/sys-schema.html
* https://dev.mysql.com/doc/refman/8.0/ja/error-handling.html
  
## 既知のバグ

## References
* https://dev.mysql.com/doc/
* https://dev.mysql.com/doc/refman/8.0/ja/
* https://dev.mysql.com/doc/refman/8.4/en/
* https://dev.mysql.com/doc/refman/5.7/en/
* https://dev.mysql.com/doc/index-archive.html
* https://downloads.mysql.com/docs/refman-5.6-ja.pdf