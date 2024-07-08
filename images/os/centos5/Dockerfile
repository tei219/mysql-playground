FROM centos:centos5

RUN sed -i 's/^mirrorlist/#mirrorlist/g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's|#baseurl=http://mirror.centos.org/centos|baseurl=http://archive.kernel.org/centos-vault|g' /etc/yum.repos.d/CentOS-* \
    && sed -i 's/^mirrorlist/#mirrorlist/g' /etc/yum.repos.d/libselinux.repo \
    && sed -i 's|#baseurl=http://mirror.centos.org/centos|baseurl=http://archive.kernel.org/centos-vault|g' /etc/yum.repos.d/libselinux.repo \
    && sed -i 's/\$releasever/5.11/g' /etc/yum.repos.d/* \
    && yum update -y \
    && yum install -y upstart

ENTRYPOINT [ "/sbin/init" ]