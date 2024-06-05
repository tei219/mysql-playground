set -f 

version(){
    local h t v

    [[ $2 = "$1" || $2 = "$3" ]] && return 0

    v=$(printf '%s\n' "$@" | sort -V)
    h=$(head -n1 <<<"$v")
    t=$(tail -n1 <<<"$v")

    [[ $2 != "$h" && $2 != "$t" ]]
}

mysql_version=$(mysql -h node1 -sNe "select @@version;")

if version 8.4.0 $mysql_version 99.0.0 ; then
	echo $(date) setting up node1

	mysql -h node1 \
		-e "set session sql_log_bin = 0;" \
		-e "create user repl@'%' identified by 'repl';" \
		-e "grant replication slave on *.* to repl@'%';" \
		-e "grant connection_admin on *.* to repl@'%';" \
		-e "grant backup_admin on *.* to repl@'%';" \
		-e "grant group_replication_stream on *.* to repl@'%';" \
		-e "flush privileges;"

	mysql -h node1 \
		-e "SET GLOBAL group_replication_bootstrap_group=ON;" \
		-e "CHANGE REPLICATION SOURCE TO SOURCE_USER='repl', SOURCE_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';" \
		-e "START GROUP_REPLICATION;" \
		-e "SET GLOBAL group_replication_bootstrap_group=OFF;"

	echo $(date) setting up node2

	mysql -h node2 \
		-e "set session sql_log_bin = 0;" \
		-e "create user repl@'%' identified by 'repl';" \
		-e "grant replication slave on *.* to repl@'%';" \
		-e "grant connection_admin on *.* to repl@'%';" \
		-e "grant backup_admin on *.* to repl@'%';" \
		-e "grant group_replication_stream on *.* to repl@'%';" \
		-e "flush privileges;"

	mysql -h node2 \
		-e "CHANGE REPLICATION SOURCE TO SOURCE_USER='repl', SOURCE_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';" \
		-e "START GROUP_REPLICATION;"

	echo $(date) setting up node3

	mysql -h node3 \
		-e "set session sql_log_bin = 0;" \
		-e "create user repl@'%' identified by 'repl';" \
		-e "grant replication slave on *.* to repl@'%';" \
		-e "grant connection_admin on *.* to repl@'%';" \
		-e "grant backup_admin on *.* to repl@'%';" \
		-e "grant group_replication_stream on *.* to repl@'%';" \
		-e "flush privileges;"
	
	mysql -h node3 \
		-e "CHANGE REPLICATION SOURCE TO SOURCE_USER='repl', SOURCE_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';" \
		-e "START GROUP_REPLICATION;"

	echo $(date) select * from performance_schema.replication_group_members
	mysql -h node3 \
		-e "select * from performance_schema.replication_group_members;"
fi