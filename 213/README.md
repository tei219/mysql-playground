# 213
## docker compose up -d 
## docker compose run --rm mysql -h node1 -e "$(cat grstatus.sql)"

# scenario
## down -> start group_replication
## (updating) down -> reset master , change master, start group_replication -> fail
## (updating) down -> data recovery -> reset master , change master, start group_replication