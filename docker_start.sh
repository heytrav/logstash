#!/bin/bash


if [ -n "$SSH_PASSWORD" ]; then
    echo "Configuring ssh: setting root password to ${SSH_PASSWORD}"
    echo "root:$SSH_PASSWORD" | chpasswd
    sed -i 's/PermitRootLogin without-password/PermitRootLogin yes/' /etc/ssh/sshd_config
    #grep "PermitRootLogin" /etc/ssh/sshd_config
    /usr/sbin/sshd
    # Append Docker environment variables, otherwise they are not accessable to ssh users
    # in any way
    env | grep _ >> /etc/environment
fi

/usr/bin/supervisord
