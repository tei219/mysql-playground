echo $(date) setting up node1
mysql -h mysql80-node1 \
	-e "SET GLOBAL group_replication_bootstrap_group=ON;" \
	-e "CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';" \
	-e "START GROUP_REPLICATION;" \
	-e "SET GLOBAL group_replication_bootstrap_group=OFF;"

echo $(date) setting up node2
mysql -h mysql80-node2 \
    -e "reset master;" \
	-e "CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';" \
	-e "START GROUP_REPLICATION;" \

echo $(date) setting up node3
mysql -h mysql80-node3 \
    -e "reset master;" \
	-e "CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';" \
	-e "START GROUP_REPLICATION;" \

echo $(date) select * from performance_schema.replication_group_members
mysql -h mysql80-node3 \
    -e "select * from performance_schema.replication_group_members;"