FROM alpine

RUN apk add openssh bash shadow mysql-client mariadb-connector-c \
    && chsh root -s /bin/bash \
    && ssh-keygen -A \
    && sed -i 's/^#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config \
    && sed -i 's/^#PermitEmptyPasswords no/PermitEmptyPasswords yes/' /etc/ssh/sshd_config \
    && echo "root:$(mkpasswd -s </dev/null)" | chpasswd -e

EXPOSE 22

ENTRYPOINT [ "/usr/sbin/sshd", "-D"]