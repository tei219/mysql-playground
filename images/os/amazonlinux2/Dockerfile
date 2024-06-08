FROM amazonlinux:2

RUN yum update -y \
    && yum install -y systemd

ENTRYPOINT [ "/sbin/init" ]