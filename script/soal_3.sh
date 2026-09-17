#!/bin/bash

# NODE ALICE
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.81.1.10
    netmask 255.255.255.0
    gateway 10.81.1.1
EOF

# NODE MIKA
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.81.1.11
    netmask 255.255.255.0
    gateway 10.81.1.1
EOF

# NODE CHISA
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.81.2.10
    netmask 255.255.255.0
    gateway 10.81.2.1
EOF

# NODE KNIGHTS
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.81.3.10
    netmask 255.255.255.0
    gateway 10.81.3.1
EOF

# NODE EIRI
cat <<EOF > /etc/network/interfaces
auto eth0
iface eth0 inet static
    address 10.81.3.11
    netmask 255.255.255.0
    gateway 10.81.3.1
EOF