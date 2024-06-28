FROM debian:12

RUN apt update -y \
    && apt install -y systemd-sysv

ENTRYPOINT [ "/sbin/init" ]