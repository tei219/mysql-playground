FROM alpine

RUN apk --no-cache add openssh bash shadow mysql-client mariadb-connector-c \
    && echo "root:$(mkpasswd -s </dev/null)" | chpasswd -e \
    && chsh root -s /bin/bash \
    && ssh-keygen -A \
    && sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    && mkdir /initer.d

COPY ./scripts/initer-entrypoint.sh /initer-entrypoint.sh

EXPOSE 22

ENTRYPOINT [ "/usr/sbin/sshd", "-D" ]