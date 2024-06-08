FROM rockylinux:9

RUN yum update -y \
    && yum install -y systemd

ENTRYPOINT [ "/sbin/init" ]