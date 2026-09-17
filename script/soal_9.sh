#!/bin/bash

# Node Chisa
cd /shared
wget -O protocol7_manifesto.zip "https://drive.google.com/drive/folders/1S3hG0dnZBTkCta4uILWwKVc6dSYYGRJ6?usp=sharing" 

# Node Mika
lftp -u mika 10.81.2.10

ftp mika@10.81.2.10
~> password: ainur123
~> !echo "percobaan upload dari mika" > upload_test.txt
~> put upload_test.txt
~> quit