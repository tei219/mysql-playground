set session sql_log_bin = 0;
create user repl@'%' identified by 'repl';
grant replication slave on *.* to repl@'%';
grant backup_admin on *.* to repl@'%';
flush privileges;