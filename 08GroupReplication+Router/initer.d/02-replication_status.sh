set -f 

echo $(date) select replication status tables on node3
for tab in \
    replication_applier_status_by_coordinator \
    replication_connection_configuration \
    replication_connection_status \
    replication_applier_status \
    replication_group_communication_information \
    replication_group_member_stats \
    replication_group_members
do
    echo "select * from $tab;"
    mysql -h node3 -e "select * from $tab;" performance_schema
done


