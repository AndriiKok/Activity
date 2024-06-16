#!/bin/bash

# Запрос имени пользователя
read -p "Введите username вашего пользователя GitHub: " username

if [ -z "$username" ]; then
  echo "Ошибка: значение не может быть пустым"
  exit 1
fi

# Запрос имени репозитория
read -p "Введите название вашего репозитория GitHub: " rep

if [ -z "$rep" ]; then
  echo "Ошибка: значение не может быть пустым"
  exit 1
fi

# Запрос директории
read -p "Введите полный путь к директории репозитрия: " folder

if [ -z "$folder" ]; then
  echo "Ошибка: значение не может быть пустым"
  exit 1
fi

# Запрос Personal Access Token
read -p "Введите ключ разработчика: " key

if [ -z "$key" ]; then
  echo "Ошибка: значение не может быть пустым"
  exit 1
fi

########################################################################################################

# Создание папки username
echo "Создаём папку $username"
user_dir="/root/github_update/$username"
mkdir -p "$user_dir"

if [ ! -d "$user_dir" ]; then
  echo "Ошибка: не удалось создать папку '$user_dir'."
  exit 1
fi

# Скачиваем скрипты
echo "Загружаем необходимые скрипты"
curl -sSL https://raw.githubusercontent.com/AndriiKok/Activity/main/ext/putScript.js > "$user_dir/putScript.js"
# curl -sSL https://github.com/AndriiKok/Activity/blob/main/deleteScript.js > "$user_dir/deleteScript.js"

mv "$user_dir/putScript.js" "$user_dir/$rep.js"

# Проверка параметров
if [ -z "$username" -o -z "$rep" -o -z "$key" -o -z "$folder" ]; then
  echo "Ошибка: username, repositoryName, token или folder не могут быть пустыми."
  exit 1
fi

# 3. Обновить файл put.js
sed -i "s/user_name/$username/g; s/rep_name/$rep/g; s/ghp_XXXXXXXXXXXXXXXXXXXXXXXXXXX/$key/g; s/folder_name/$folder/g" $user_dir/$rep.js

# 4. Проверка обновления
if [ $? -ne 0 ]; then
  echo "Ошибка: не удалось обновить файл put.js."
  exit 1
fi

# 5. Подтверждение
echo "Файл put.js успешно обновлен."
