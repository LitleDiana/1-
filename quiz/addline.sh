#!/bin/bash

directory="$1"

# Проверка аргумента на наличие и является ли он каталогом
if [ -z "$directory" ] || [ ! -d "$directory" ]; then
    echo "Ошибка: Пожалуйста, укажите действительный путь к каталогу."
    exit 1
fi

# Получение логина пользователя
user_name=$(whoami)

# Получение текущей даты в формате ISO 8601
date=$(date -I)

# Обработка файлов в каталоге
for file in "$directory"/*.txt; do
    if [ -f "$file" ]; then
        # Добавление строки в файл
        echo "Approved $user_name $date" | cat - "$file" > temp && mv temp "$file"
    fi
done
