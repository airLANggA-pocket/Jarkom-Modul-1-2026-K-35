#!/bin/bash

# Node Chisa
apk add busybox-extras
telnetd -l /bin/login &
netstat -tlnp | grep 23
apk add net-tools

adduser -D phantom_user
passwd phantom_user

# Node Eiri
telnet 10.81.2.10
# login: phantom_user
# password: wired_ghost
exit