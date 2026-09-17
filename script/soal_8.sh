#!/bin/bash [BELUM SELESAI]

# Node Knights
wget knights.zip "https://drive.google.com/drive/folders/1tvZpueSH9E3GWwXM6KNnM64Y5wNoIAYP?usp=sharing"
lftp -u alice,password_alice -e "put knights_report.txt; quit" 10.81.2.10

unzip knights_report.zip

ftp alice@10.81.2.10
~> password: alice
~> passive
~> put knights_report.txt
~> exit
~> EOF