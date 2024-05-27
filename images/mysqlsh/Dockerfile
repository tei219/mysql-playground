FROM ubuntu

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update \
  && apt install -y wget \
  && wget http://repo.mysql.com/mysql-apt-config_0.8.30-1_all.deb \
  && apt install -y ./mysql-apt-config_0.8.30-1_all.deb \
  && apt update \
  && apt install -y mysql-shell

ENTRYPOINT [ "/usr/bin/mysqlsh"]