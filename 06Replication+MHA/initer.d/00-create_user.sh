set -f
echo $(date) $0

echo "$(date) setting up root@'%'"
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null node1 "mysql -e \"create user root@'%' identified by ''; grant all PRIVILEGES on *.* to root@'%' with grant option;\""
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null node2 "mysql -e \"create user root@'%' identified by ''; grant all PRIVILEGES on *.* to root@'%' with grant option;\""
ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null node3 "mysql -e \"create user root@'%' identified by ''; grant all PRIVILEGES on *.* to root@'%' with grant option;\""