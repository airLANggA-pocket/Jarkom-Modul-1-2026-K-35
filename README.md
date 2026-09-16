# Lapres Jarkom-Modul-1-2026-K-35

# Daftar Isi

- [Lapres Jarkom-Modul-1-2026-K-35](#lapres-jarkom-modul-1-2026-k-35)
  - [Data Kelompok & IP Setup](#ip-address-host--10489247)
- [Serial Experiments Lain](#serial-experiments-lain)
  - [Soal 1: Topologi Jaringan](#soal_1)
  - [Soal 2: Konfigurasi Router Lain ke Internet (NAT/DHCP)](#soal_2)
  - [Soal 3: Konfigurasi Routing & Static IP Client](#soal_3)
  - [Soal 4: Firewall, NAT Masquerade & DNS Resolver](#soal_4)
  - [Soal 5: Persistensi Konfigurasi & Script Verifikasi](#soal_5)
  - [Soal 6](#soal_6)

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

![](photo/thewired.png)

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

![](photo/configrouterlain.png)

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
![](photo/ipaddr.png)

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
![](photo/aliceping.png)
Mika to others
![](photo/mikaping.png)
Chisa to others
![](photo/chisaping.png)
Knights to others
![](photo/eiriping.png)
Eiri to others
![](photo/eiriping.png)

## Soal_4
Lain ingin agar setiap Entitas (Client) memiliki kemandirian di The
Wired. Konfigurasikan firewall/iptables (NAT Masquerade) dan DNS
resolver agar setiap Client dapat terhubung ke internet secara mandiri
(dapat melakukan ping ke 8.8.8.8 dan membuka domain web
google.com).

Agar client dapat ping ke 8.8.8.8 dan resolve domain google.com secara mandiri kita perlu mengecek file /etc/resolve.cong

![](photo/resolve.png)

Resolving servernya adalah 10.81.1.1 maka IP ini akan ditambahkan ke masing masing client.

Selanjutnya kita mengecek apakah masing-masing client dapat terhubung ke internet atau tidak.

![](photo/chisagoogle.png)

Jawabannya client dapat terhubung ke internet

## Soal_5
Eiri tetap berupaya menanamkan kekacauan ke dalam jaringan. Untuk
mengantisipasi restart tiba-tiba, pastikan seluruh konfigurasi jaringan
tidak hilang saat semua node di-restart. Buat script verifikasi di
/root/cek_status.sh pada router Lain yang menampilkan ringkasan
interface (ip -br a) dan status tabel NAT (iptables -t nat -L -v -n)
setelah reboot.

Sebelum restart, pastikan RouterLain punya presistensi di /etc/network/interfaces.

```
auto eth0
iface eth0 inet dhcp
    up sysctl -w net.ipv4.ip_forward=1
    up iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
    up iptables -A FORWARD -i eth1 -o eth0 -j ACCEPT
    up iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
    up iptables -A FORWARD -i eth3 -o eth0 -j ACCEPT
    up iptables -A FORWARD -i eth0 -m state --state ESTABLISHED,RELATED -j ACCEPT
    up dnsmasq -C /etc/dnsmasq.conf

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

Cek status_sh
![](photo/cekstatus_sh.png)

Lalu kita coba verivikasi pada client 

![](photo/chisapinggoogle.png)

## Soal_6
Mika mencurigai adanya anomali traffic pada segmen jaringannya.
Jalankan generator traffic berikut (link file) pada node Mika, lalu
lakukan packet sniffing menggunakan Wireshark pada interface node
Mika. Terapkan display filter khusus untuk menyaring paket yang
berprotokol DNS atau ICMP. Tunjukkan screenshot hasil filter beserta
ringkasan paket yang lolos.







## Soal_8
Kelompok rahasia Knights perlu mengirimkan dokumen laporan
intelijen ke FTP Server Chisa. Lakukan koneksi FTP client dari node
Knights ke FTP Server Chisa menggunakan akun alice. Upload file
berikut (link file). Analisis sesi Wireshark dan sebutkan: perintah FTP
untuk upload (STOR), kode status sukses server (226), dan port data
TCP yang dinegosiasikan pada mode PASV.

Awal-awal kita perlu mendownload file zip pada link soal dengan cara.
```
wget knights.zip "https://drive.google.com/drive/folders/1tvZpueSH9E3GWwXM6KNnM64Y5wNoIAYP?usp=sharing"
lftp alice@10.81.2.10
```

![](photo/knightsping.png)

Selanjutnya kita melakukan capturing traffic dari kabel Knights dan Switch 3

![](photo/captureno8.png)

Bukti capturing

![](photo/bukticapturingno8.png)

## Soal_9
Mika mengakses dokumen Protokol Tujuh di (link file) dari FTP Server
Chisa. Dari node Mika, unduh file tersebut menggunakan akun mika.
Setelah itu, buktikan pembatasan read-only dengan mencoba
mengunggah file baru dari akun mika, dan tunjukkan pesan error
respon server (error 550 Permission denied) saat mika mencoba
melakukan upload.

Pada awal kita mendownload protocol7_manifesto dari Chisa.

```
cd /shared
wget -O protocol7_manifesto.zip "https://drive.google.com/drive/folders/1S3hG0dnZBTkCta4uILWwKVc6dSYYGRJ6?usp=sharing" 
```

![](photo/protocolmanifesto.png)

Selanjutnya kita melakukan capture pada Wireshark dan melakukan set filter di wireshark

```
ftp || ftp-data
```

![](photo/captureno9.png)

Pada node Mika kita butuh akses dokumen pada server Chisa.
```
lftp mika@10.81.2.10
```
Masukkan password yang sudah dibuat lalu ambil dokumen tersebut 

![](photo/getprotocol.png)

tunggu sampai selesai lalu cek di wireshark
![](photo/bukticaptureno9.png)

## Soal_10
Knights melancarkan uji ketahanan koneksi ke server Chisa untuk
menguji latensi jaringan The Wired. Kirimkan paket ping dari node
Knights ke node Chisa dengan payload khusus 128 bytes dan interval
0.3 detik sebanyak 77 paket (ping -c 77 -s 128 -i 0.3 <IP_Chisa>). Buka
Wireshark, catat nilai ICMP Type dan Code untuk Echo Request vs Echo
Reply, serta analisis packet loss dan RTT (min/avg/max).

Kita perlu mengirim ping dari node Knights ke node Chisa dengan ping.
```
ping -c 77 -s 128 -i 0.3 10.81.2.10
```

Penjelasan flag:

- c 77 → kirim 77 paket
- s 128 → ukuran payload 128 byte
- i 0.3 → interval 0.3 detik antar paket

Tunggu sampai selesai lalu cek di terminal dan wireshark

![](photo/pingknightsno10.png)
![](photo/bukticaptureno10.png)

