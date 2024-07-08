LBでやったほうが無難かも

# Group Replication となにかしら Proxy/LB
## なにするだ
### 起動するやつリスト
## Group Replication のトポロジ
## シナリオ

```
:~/mysql-playground/08GroupReplication+Router$ docker compose logs haproxy
haproxy-1  | [NOTICE]   (1) : haproxy version is 2.8.10-f28885f
haproxy-1  | [WARNING]  (1) : config : Proxy 'mysql_write_backend' : 'insecure-fork-wanted' not enabled in the global section, 'option external-check' will likely fail.
haproxy-1  | [WARNING]  (1) : config : Proxy 'mysql_readonly_backend' : 'insecure-fork-wanted' not enabled in the global section, 'option external-check' will likely fail.
haproxy-1  | [WARNING]  (1) : Server mysql_write_backend/node2 is DOWN, reason: External check error, code: 1, check duration: 18ms. 2 active and 0 backup servers left. 0 sessions active, 0 requeued, 0 remaining in queue.
haproxy-1  | [WARNING]  (1) : Server mysql_write_backend/node3 is DOWN, reason: External check error, code: 1, check duration: 19ms. 1 active and 0 backup servers left. 0 sessions active, 0 requeued, 0 remaining in queue.
haproxy-1  | [WARNING]  (1) : Server mysql_readonly_backend/node1 is DOWN, reason: External check error, code: 1, check duration: 20ms. 2 active and 0 backup servers left. 0 sessions active, 0 requeued, 0 remaining in queue.
```

## 既知のバグ
## References
* https://dev.mysql.com/doc/refman/8.0/ja/group-replication.html