# Lapres Jarkom-Modul-1-2026-K-35

| Nama | NRP |
| ---------------------- | ---------- |
| Dea Chrisna Butarbutar | 5027241035 |
| Pradipta Airlangga Ramadhan | 5027241118 |
----


# IP Address Host : 10.4.89.247

# IP Prefix : 10.81.x.x

# Serial Experiments Lain

## Soal_1

Untuk mempersiapkan pembangunan The Wired, Lain yang berperan
sebagai Router membuat tiga Switch/Gateway: Switch 1 menuju dua
Entitas yaitu Alice dan Mika, Switch 2 menuju Chisa, sedangkan Switch 3
menuju Knights dan Eiri. Kelima Entitas tersebut dikonfigurasi sebagai
Client di GNS3.

<img src="../Jarkom-Modul-1-2026-K-35/photo/thewired.png" />

Kami membuat topologi jaringan sesuai dengan intruksi soal

Syarat:
- NAT : Sebagai dynamic IP DHCP dan bisa terkoneksi ke internet.
-RouterLain : Sebagai networking yang terhubung dengan NAT.
- Switch 1 dan 2 dan 3 : Sebagai gateway client yang terkoneksi ke internet.
- Client (Alice, Mika, Chisa, Knights, Eiri) : Client yang terhubung dalam topologi jaringan

## Soal_2
Karena menurut Lain pada saat itu The Wired masih terisolasi dari
dunia luar, konfigurasikan router Lain agar dapat tersambung
langsung ke jaringan internet publik melalui NAT/DHCP pada interface
eth0.

<img src="../Jarkom-Modul-1-2026-K-35/photo/configrouterlain.png"/>

```
#!?bin/sh
auto eth0
iface eth0 inet dhcp

auto eth1
iface eth1 inet static
    address 10.81.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.81.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.81.3.1
    netmask 255.255.255.0
EOF

rc-update add networking boot
rc-service networking restart
```

Agar RouterLain dapat terkoneksi kita melakukan interface RouterLain yang terhubung ke NAT untuk mendapat IP DHCP, dengan configurasi yang dimasukkan /root/script.sh

```
auto eth0
iface eth0 inet dhcp
```
Ini untuk melakukan setup interface eth0 yang terhubung ke NAT mendapatkan alamat IP dari DHCP tersebut

## Soal_3
Setelah router Lain terhubung ke internet, pastikan seluruh Entitas
(Client) di bawah Switch 1, Switch 2, dan Switch 3 dapat saling
terhubung dan berkomunikasi satu sama lain melalui konfigurasi
routing.

Karena switch terhubung dengan RouterLain, maka konfigurasi interface router kita buat terhubung ke switch 1, 2, 3, dengan konfigurasi:

```
auto eth1
iface eth1 inet static
    address 10.81.1.1
    netmask 255.255.255.0

auto eth2
iface eth2 inet static
    address 10.81.2.1
    netmask 255.255.255.0

auto eth3
iface eth3 inet static
    address 10.81.3.1
    netmask 255.255.255.0
```
Prefix kelompok kami adalah 10.81.x.x

Selanjutnya kami mengecek interface apakah memiliki IP yang benar atau salah, degan menggunakan ip adrr show
 <img src="../Jarkom-Modul-1-2026-K-35/photo/ipaddr.png"/>

 Pada gambar ini, sudah jelas interface memiliki IP yang sesuai dengan apa yang sudah dikonfigurasikan

Lalu, kita buat tiap client memiliki alokasi IP sendiri, yaitu degan melakukan konfigurasi static ip di tiap client dan juga gateway dibuat spesifik sesuai dengan switch dari tiap client tersebut terhubung. 

Alice
```
auto eth0
iface eth0 inet static
    address 10.81.1.10
    netmask 255.255.255.0
    gateway 10.81.1.1
```

Mika
```
auto eth0
iface eth0 inet static
    address 10.81.1.11
    netmask 255.255.255.0
    gateway 10.81.1.1
```

Chisa
```
auto eth0
iface eth0 inet static
    address 10.81.2.10
    netmask 255.255.255.0
    gateway 10.81.2.1
```
Knights
```
auto eth0
iface eth0 inet static
    address 10.81.3.10
    netmask 255.255.255.0
    gateway 10.81.3.1
```

Eiri
```
auto eth0
iface eth0 inet static
    address 10.81.3.11
    netmask 255.255.255.0
    gateway 10.81.3.1
```

Lalu, kita melakukan test ping pada client.

ALice to Others
<img src="../Jarkom-Modul-1-2026-K-35/photo/aliceping.png" />
Mika to others
<img src="../Jarkom-Modul-1-2026-K-35/photo/mikaping.png" />
Chisa to others
<img src="../Jarkom-Modul-1-2026-K-35/photo/chisaping.png" />
Knights to others
<img src="../Jarkom-Modul-1-2026-K-35/photo/knightsping.png" />
Eiri to others
<img src="../Jarkom-Modul-1-2026-K-35/photo/eiriping.png" />

## Soal_4
Lain ingin agar setiap Entitas (Client) memiliki kemandirian di The
Wired. Konfigurasikan firewall/iptables (NAT Masquerade) dan DNS
resolver agar setiap Client dapat terhubung ke internet secara mandiri
(dapat melakukan ping ke 8.8.8.8 dan membuka domain web
google.com).

Agar client dapat ping ke 8.8.8.8 dan resolve domain google.com secara mandiri kita perlu mengecek file /etc/resolve.cong

<img src="../Jarkom-Modul-1-2026-K-35/photo/resolve.png">

Resolving servernya adalah 10.81.1.1 maka IP ini akan ditambahkan ke masing masing client.

Selanjutnya kita mengecek apakah masing-masing client dapat terhubung ke internet atau tidak.

<img src="../Jarkom-Modul-1-2026-K-35/photo/chisagoogle.png">

Jawabannya client dapat terhubung ke internet

## Soal_5
Eiri tetap berupaya menanamkan kekacauan ke dalam jaringan. Untuk
mengantisipasi restart tiba-tiba, pastikan seluruh konfigurasi jaringan
tidak hilang saat semua node di-restart. Buat script verifikasi di
/root/cek_status.sh pada router Lain yang menampilkan ringkasan
interface (ip -br a) dan status tabel NAT (iptables -t nat -L -v -n)
setelah reboot.



