FROM amazonlinux:2023

RUN yum update -y \
    && yum install -y systemd

ENTRYPOINT [ "/sbin/init" ]