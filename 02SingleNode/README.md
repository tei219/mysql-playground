シングルノード

やること
必要なコンフィグ？
サイズチェック？

backup
バージョン間の違い
エラー対応


# Single Node
## なにするだ
MySQL の単体構成時の挙動やバージョン間での差異について学びます

[ 概要図 ]

各コンテナのパスワードは **なし** で作ってますです  

### 起動するやつリスト 
| service | hostname  | image         | profile | note          |
| ------- | --------- | ------------- | ------- | ------------- |
| node1   | node1     | (mysql:8.0)   |         | パスなし      |
| ladder  | ladder    | ladder:latest |         | パスなし sshd |
| mysql   | (dynamic) | ladder:latest | extra   |               |
| mysqlsh | (dynamic) | mysqlsh       | extra   |               |

※`profile` が `extra` になっているものは自動起動しません  

## シナリオ
 * [バージョン間の違いを確認する](./scenario01/README.md)
 * [エラーを確認する](./scenario02/README.md)
 * [権限管理をする](./scenario03/README.md)
 * [バックアップを取得する](./scenario04/README.md)