# Playground
## なにするだ
プレイグラウンド環境を理解します。環境の概要は下記のとおりです

[ 概要図 ]

各コンテナのパスワードは **なし** で作ってますです  

### 起動するやつリスト 
| service | hostname  | image         | profile | note          |
| ------- | --------- | ------------- | ------- | ------------- |
| mysql84 | (dynamic) | mysql:8.4     | extra   | パスなし      |
| mysql80 | (dynamic) | mysql:8.0     |         | パスなし      |
| mysql57 | (dynamic) | mysql:5.7     | extra   | パスなし      |
| mysql56 | (dynamic) | mysql:5.6     | extra   | パスなし      |
| ladder  | (dynamic) | ladder:latest |         | パスなし sshd |
| mysql   | (dynamic) | ladder:latest | extra   |               |

※`profile` が `extra` になっているものは自動起動しません  

## シナリオ
 * [環境を理解する](./scenario01/README.md)