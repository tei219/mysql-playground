FROM debian:10

RUN apt update -y \
    && apt install -y systemd

ENTRYPOINT [ "/sbin/init" ]