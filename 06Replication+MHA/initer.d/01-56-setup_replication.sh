set -f 
echo $(date) $0

version(){
    local h t v

    [[ $2 = "$1" || $2 = "$3" ]] && return 0

    v=$(printf '%s\n' "$@" | sort -V)
    h=$(head -n1 <<<"$v")
    t=$(tail -n1 <<<"$v")

    [[ $2 != "$h" && $2 != "$t" ]]
}

mysql_version=$(mysql -h node1 -sNe "select @@version;")

if version 5.6.0 $mysql_version 5.6.99 ; then
	echo $(date) setting up node1

	mysql -h node1 \
		-e "set session sql_log_bin = 0;" \
		-e "create user repl@'%' identified by 'repl';" \
		-e "grant replication slave on *.* to repl@'%';" \
		-e "flush privileges;"

	master_status=$(mysql -h node1 -sNe "show master status;")
	sql=$(echo $master_status | awk '{print "change master to master_host=\047node1\047, \
	  master_user=\047repl\047, \
	  master_password=\047repl\047, \
	  master_log_file=\047"$1"\047, " \
	  "master_log_pos="$2";"}')
	echo $sql

	echo $(date) setting up node2

	mysql -h node2 \
		-e "set session sql_log_bin = 0;" \
		-e "create user repl@'%' identified by 'repl';" \
		-e "grant replication slave on *.* to repl@'%';" \
		-e "flush privileges;"

	mysql -h node2 \
		-e "$sql" \
		-e "start slave;"

	echo $(date) setting up node3

	mysql -h node3 \
		-e "set session sql_log_bin = 0;" \
		-e "create user repl@'%' identified by 'repl';" \
		-e "grant replication slave on *.* to repl@'%';" \
		-e "flush privileges;"

	mysql -h node3 \
		-e "$sql" \
		-e "start slave;"
fi