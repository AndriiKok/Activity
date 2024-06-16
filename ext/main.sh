#!/bin/bash

read -p "Введите username вашего пользователя GitHub: " username
read -p "Введите название вашего репозитория GitHub: " rep
read -p "Введите полный путь к директории репозитрия: " folder
read -p "Введите ключ разработчика: " key

# Создание папки username
echo "Создаём папку $username"
user_dir="/root/github_update/$username"
mkdir -p "$user_dir"

# Скачиваем скрипты
echo "Загружаем необходимые скрипты"
curl -sSL https://raw.githubusercontent.com/AndriiKok/Activity/main/ext/putScript.js > "$user_dir/putScript.js"
curl -sSL https://raw.githubusercontent.com/AndriiKok/Activity/main/ext/deleteScript.js > "$user_dir/deleteScript.js"

mv "$user_dir/putScript.js" "$user_dir/$rep-put.js"
mv "$user_dir/deleteScript.js" "$user_dir/$rep-delete.js"

# 3. Обновить файл put.js
cd $user_dir
find . -type f -exec sed -i "s/user_name/$username/g" {} + 
find . -type f -exec sed -i "s/rep_name/$rep/g" {} + 
find . -type f -exec sed -i "s/folder_name/\"$folder\"/g" {} + 
find . -type f -exec sed -i "s/ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXX/$key/g" {} +

# 5. Подтверждение
echo "Файл put.js успешно обновлен."
