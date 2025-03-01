FROM almalinux:8

WORKDIR /work

RUN dnf -y update && dnf -y install epel-release wget gcc mysql-devel cpan \
    && wget https://github.com/yoshinorim/mha4mysql-node/releases/download/v0.58/mha4mysql-node-0.58.tar.gz \
    && wget https://github.com/yoshinorim/mha4mysql-manager/releases/download/v0.58/mha4mysql-manager-0.58.tar.gz \
    && tar xvf mha4mysql-node-0.58.tar.gz \
    && tar xvf mha4mysql-manager-0.58.tar.gz \
    && cpan -f Module::Install \
    && cpan -f DBI DBD::mysql \
    && cpan -f Config::Tiny Log::Dispatch Parallel::ForkManager

WORKDIR /work/mha4mysql-node-0.58

RUN perl Makefile.PL && make && make install

WORKDIR /work/mha4mysql-manager-0.58

RUN perl Makefile.PL && make && make install

ENTRYPOINT [ "/bin/bash" ]