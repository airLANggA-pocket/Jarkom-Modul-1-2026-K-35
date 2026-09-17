#!/bin/bash

# NODE ALICE
# Siapkan port SSH
apk add openssh

# Jalankan servicenya
ssh-keygen -A
/usr/sbin/sshd

# Cek jalan listen di port SSH
netstat -tlnp | grep :22

# NODE KNIGHTS
# Jika belum install
apk add python3

python3 -m http.server 80 &

# Cek jalan
netstat -tlnp | grep :80

# NODE ALICE
which nc
nc -zv -w 2 10.81.3.10 22
nc -zv -w 2 10.81.3.10 80
nc -zv -w 2 10.81.3.10 7777