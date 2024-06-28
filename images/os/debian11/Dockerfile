FROM debian:11

RUN apt update -y \
    && apt install -y systemd-sysv

ENTRYPOINT [ "/sbin/init" ]