# MHA
## なにするだ
MHA 構成と挙動を学びます

```sh
 ┌─ docker compose ──────────────────────────────────────────────────────┐ 
 │                                                                       │ 
 │                                                                       │ 
 │  ─────┬───────┬─────────────────┬─────┬─────┬─────────┬─────────┬──── │ 
 │       │       │                 │     │     │         │         │     │ 
 │   ┌───┴──┐ ┌──┴──┐           ┌──┴───┐ │ ┌───┴───┐ ┌───┴───┐ ┌───┴───┐ │ 
 │   │ladder│ │mysql│           │initer│ │ │ node1 │ │ node2 │ │ node3 │ │ 
 │   │      │ │extra│           │      │ │ │       │ │       │ │       │ │ 
 │   └──*───┘ └─────┘           └──────┘ │ └───────┘ └───────┘ └───────┘ │ 
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

## 既知のバグ
* docker なのでコンテナを落とすと名前が引けずに MHA によるフェイルオーバーが失敗します  
  manager で masterha_manager 起動後 node1 を stop
  ```sh
  [root@manager ~]# masterha_manager --conf=/etc/app1.cnf 
  ...
  Fri Jun 28 09:54:38 2024 - [info] Ping(SELECT) succeeded, waiting until MySQL doesn't respond..

  Fri Jun 28 09:56:35 2024 - [warning] Got error on MySQL select ping: 2006 (MySQL server has gone away)
  Fri Jun 28 09:56:35 2024 - [info] Executing SSH check script: save_binary_logs --command=test --start_pos=4 --binlog_dir=/var/lib/mysql,/var/log/mysql --output_file=/usr/local/mha/save_binary_logs_test --manager_version=0.58 --binlog_prefix=node1-bin
  Fri Jun 28 09:56:40 2024 - [warning] HealthCheck: Got timeout on checking SSH connection to node1! at /usr/share/perl5/vendor_perl/MHA/HealthCheck.pm line 343.
  Fri Jun 28 09:56:41 2024 - [warning] Got error on MySQL connect: 2003 (Can't connect to MySQL server on '172.23.0.2' (4))
  Fri Jun 28 09:56:41 2024 - [warning] Connection failed 2 time(s)..
  Fri Jun 28 09:56:44 2024 - [warning] Got error on MySQL connect: 2003 (Can't connect to MySQL server on '172.23.0.2' (4))
  Fri Jun 28 09:56:44 2024 - [warning] Connection failed 3 time(s)..
  Fri Jun 28 09:56:47 2024 - [warning] Got error on MySQL connect: 2003 (Can't connect to MySQL server on '172.23.0.2' (4))
  Fri Jun 28 09:56:47 2024 - [warning] Connection failed 4 time(s)..
  Fri Jun 28 09:56:47 2024 - [warning] Master is not reachable from health checker!
  Fri Jun 28 09:56:47 2024 - [warning] Master node1(172.23.0.2:3306) is not reachable!
  Fri Jun 28 09:56:47 2024 - [warning] SSH is NOT reachable.
  Fri Jun 28 09:56:47 2024 - [info] Connecting to a master server failed. Reading configuration file /etc/masterha_default.cnf and /etc/app1.cnf again, and trying to connect to all servers to check server status..
  Fri Jun 28 09:56:47 2024 - [warning] Global configuration file /etc/masterha_default.cnf not found. Skipping.
  Fri Jun 28 09:56:47 2024 - [info] Reading application default configuration from /etc/app1.cnf..
  Fri Jun 28 09:56:47 2024 - [info] Reading server configuration from /etc/app1.cnf..
  Fri Jun 28 09:56:55 2024 - [warning] Got Error: Failed to get IP address on host node1: Name or service not known
  at /usr/share/perl5/vendor_perl/MHA/Config.pm line 63.
  Fri Jun 28 09:56:55 2024 - [info] Got exit code 1 (Not master dead).
  ```

# Reference
* https://code.google.com/archive/p/mysql-master-ha/
* https://github.com/yoshinorim/mha4mysql-manager
* https://github.com/yoshinorim/mha4mysql-node
