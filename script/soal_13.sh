#!/bin/bash

# NODE KNIGHTS
apk add openssh
ssh-keygen -A
/usr/sbin/sshd

netstat -tlnp | grep :22
adduser -D mika_admin
echo "mika_admin:dummy123" | chpasswd

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0owaJOoafALSTwkHXrDWCB9lbo9D8OlHnsgQy59rEZ" >> /home/mika_admin/.ssh/authorized_keys

# NODE MIKA
ssh-keygen -t ed25519
ls -l /root/.ssh/

# NODE KNIGHTS
mkdir -p /home/mika_admin/.ssh
echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM0owaJOoafALSTwkHXrDWCB9lbo9D8OlHnsgQy59rEZ" >> /home/mika_admin/.ssh/authorized_keys

# NODE MIKA
ssh mika_admin@10.81.3.10