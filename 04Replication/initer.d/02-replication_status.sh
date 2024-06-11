set -f 

echo $(date) show slave status each node
for node in \
    node1 \
    node2 \
    node3 
do
    echo "show master status on $node"
    mysql -h $node -e "show master status\G"
    echo "show slave status on $node"
    mysql -h $node -e "show slave status\G"

    echo "show binary log status on $node"
    mysql -h $node -e "show binary log status\G"
    echo "show replica status on $node"
    mysql -h $node -e "show replica status\G"
done


