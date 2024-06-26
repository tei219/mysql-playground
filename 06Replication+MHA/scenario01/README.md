ssh check
```sh
[root@manager ~]# masterha_check_ssh --conf=/etc/app1.cnf
```

repl check
```sh
[root@manager ~]# masterha_check_repl --conf=/etc/app1.cnf
```


マスターの切り替え　旧マスタはそのまま  
```sh
[root@manager ~]# masterha_master_switch --conf=/etc/app1.cnf --master_state=alive --new_master_host=node2
```

master switch, old is new slave
```sh
[root@manager ~]# masterha_master_switch --conf=/etc/app1.cnf --master_state=alive --orig_master_is_new_slave --new_master_host=node1
```

mysql service stop, failover
```sh
[root@manager ~]# masterha_manager --conf=/etc/app1.cnf 
..

[root@node1 ~]# systemctl stop mysqld
```