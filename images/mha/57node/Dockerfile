FROM centos:7

RUN yum install -y wget perl-DBD-MySQL perl-Config-Tiny perl-Log-Dispatch perl-Parallel-ForkManager \
    && wget https://github.com/yoshinorim/mha4mysql-node/releases/download/v0.58/mha4mysql-node-0.58-0.el7.centos.noarch.rpm \
    && yum install -y mha4mysql-node-0.58-0.el7.centos.noarch.rpm \
    && wget http://repo.mysql.com/mysql-community-release-el7.rpm \
    && yum install -y mysql-community-release-el7.rpm \
    && yum-config-manager --disable mysql80-community \
    && yum-config-manager --enable mysql57-community \
    && rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022 \
    && yum install -y mysql-community-server

ENTRYPOINT [ "/sbin/init" ]
