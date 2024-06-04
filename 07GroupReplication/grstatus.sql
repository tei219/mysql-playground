select
    gm.*,
    if(gs.variable_value is null, '', '*') as master,
    if(gm.member_host = @@hostname, '*', '') as connected
from
    performance_schema.replication_group_members as gm
    left join
    performance_schema.global_status as gs
    on
        gm.member_id = gs.variable_value;

select @@global.gtid_executed;