#!/bin/bash

# Jalankan pada node Mika
apk update
apk add unzip wget
wget -O traffic.zip "https://drive.google.com/drive/folders/1ZjFvWIjvAQAjE9pPthm7V_bGyaSt93lY?usp=sharing"
unzip traffic_protocol7.zip
sh traffic_protocol7.sh