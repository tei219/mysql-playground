FROM centos:7

RUN yum install -y wget \
    perl-DBD-MySQL perl-Config-Tiny perl-Log-Dispatch perl-Parallel-ForkManager \
    iproute openssh-server openssh-clients epel-release \
    && wget https://github.com/yoshinorim/mha4mysql-node/releases/download/v0.58/mha4mysql-node-0.58-0.el7.centos.noarch.rpm \
    && yum install -y mha4mysql-node-0.58-0.el7.centos.noarch.rpm \
    && wget https://github.com/yoshinorim/mha4mysql-manager/releases/download/v0.58/mha4mysql-manager-0.58-0.el7.centos.noarch.rpm \
    && yum install -y mha4mysql-manager-0.58-0.el7.centos.noarch.rpm \
    && sed -i 's/^#PermitRootLogin/PermitRootLogin/' /etc/ssh/sshd_config \
    && sed -i 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    && echo root: | chpasswd \
    && systemctl enable sshd \
    && mkdir /root/.ssh \
    && chmod 700 /root/.ssh 

COPY ./sshkeys/* /root/.ssh/

RUN chmod 600 /root/.ssh/id_rsa.pub && cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

ENTRYPOINT [ "/sbin/init" ]
