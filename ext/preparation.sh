#!/bin/bash

echo -e "Устанавливаем nodejs и необходимые приложения"
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg unzip
sudo mkdir -p /etc/apt/keyrings
rm -f /etc/apt/keyrings/nodesource.gpg
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

echo -e "Устанавливаем используемые в скриптах npm пакеты"
sudo apt-get update
npm install axios js-base64 fs path

echo -e "Создаём основную директорию и загружаем каталог с хорошим кодом"
sudo mkdir /root/github_update && cd /root/github_update
curl -fsSL https://github.com/AndriiKok/Activity/raw/main/ext/files.zip
unzip -q files.zip && rm files.zip
