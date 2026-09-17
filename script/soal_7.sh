#!/bin/bash

# Jalankan pada node Chisa
apk update
apk add vsftpd

cat <<EOF > /etc/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_root=/var/wired/data
chroot_local_user=YES
allow_writeable_chroot=YES
user_config_dir=/etc/vsftpd_users
userlist_enable=YES
userlist_deny=YES
userlist_file=/etc/vsftpd.user_list
listen=YES
listen_ipv6=NO
pam_service_name=vsftpd
seccomp_sandbox=NO
EOF

mkdir -p /etc/vsftpd_users

sed -i 's#:/bin/false$#:/bin/sh#' /etc/passwd

cat <<EOF > /etc/vsftpd_users/alice
write_enable=YES
download_enable=YES
dirlist_enable=YES
EOF

cat <<EOF > /etc/vsftpd_users/mika
write_enable=NO
download_enable=YES
dirlist_enable=YES
EOF

echo "eiri" > /etc/vsftpd.user_list

vsftpd /etc/vsftpd/vsftpd.conf &

# Node Alice
lftp -u alice 10.81.2.10

ftp alice@10.81.2.10
~> password: alice
~> put signal_alice.txt
~> ls -l /var/wired/data
~> exit

# Node Mika
echo "File from Mika" > signal_mika.txt
cat signal mika.txt
lftp -u mika 10.81.2.10

ftp mika@10.81.2.10
~> password: mika
~> put signal_mika.txt
~> exit

# Node Eiri
lftp -u eiri 10.81.2.10

ftp eiri@10.81.2.10
~> ls
~> exit