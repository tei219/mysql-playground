#!/bin/bash

docker compose run --rm mysql -h mysql80-node1 \
	-e "SET GLOBAL group_replication_bootstrap_group=ON;" \
	-e "CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';" \
	-e "START GROUP_REPLICATION;" \
	-e "SET GLOBAL group_replication_bootstrap_group=OFF;"

docker compose run --rm mysql -h mysql80-node2 \
        -e "reset master;" \
	-e "CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';" \
	-e "START GROUP_REPLICATION;" \

docker compose run --rm mysql -h mysql80-node3 \
        -e "reset master;" \
	-e "CHANGE MASTER TO MASTER_USER='repl', MASTER_PASSWORD='repl' FOR CHANNEL 'group_replication_recovery';" \
	-e "START GROUP_REPLICATION;" \