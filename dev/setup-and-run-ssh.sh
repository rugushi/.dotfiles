#!/bin/bash

mkdir -p /run/sshd
mkdir -p /root/.ssh
chmod 700 /root/.ssh

RPC=$(openssl rand -base64 12)
echo "root:$RPC" | chpasswd
echo "---------------------------------------------------"
echo " DEV PASSWORD: $RPC "
echo "---------------------------------------------------"

sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config
sed -i 's/^#\?PubkeyAuthentication.*/PubkeyAuthentication yes/' /etc/ssh/sshd_config

echo "AuthorizedKeysFile .ssh/authorized_keys" >> /etc/ssh/sshd_config

sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config

touch /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys

echo "Starting SSH server on port 22..."
exec /usr/sbin/sshd -D
