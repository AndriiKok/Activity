#!/bin/bash

echo -e "Устанавливаем nodejs и всё необходимое"
sudo apt-get update
sudo apt-get install -y ca-certificates curl gnupg unzip
sudo mkdir -p /etc/apt/keyrings
rm -f /etc/apt/keyrings/nodesource.gpg
curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg
NODE_MAJOR=20
echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | sudo tee /etc/apt/sources.list.d/nodesource.list

sudo apt-get update
npm install axios js-base64 fs path

sudo mkdir /root/github_update && cd /root/github_update
curl -fsSL https://github.com/AndriiKok/Activity/raw/main/ext/files.zip > "/root/github_update/files.zip"
unzip -q -d /root/github_update files.zip && rm -rf /root/github_update/files.zip
echo -e "Готово, продолжайте по гайду"
