FROM rockylinux:8

RUN yum update -y \
    && yum install -y systemd

ENTRYPOINT [ "/sbin/init" ]