#!/bin/bash

# Функция для вывода сообщения об ошибке и завершения скрипта
die() {
  echo "$1" >&2
  exit 1
}

# Проверка наличия нужного количества аргументов
if [ "$#" -ne 3 ]; then
  die "Использование: $0 <путь_к_каталогу> <старый_суффикс> <новый_суффикс>"
fi

# Параметры скрипта
directory="$1"
old_suffix="$2"
new_suffix="$3"

# Проверка, что директория существует
if [ ! -d "$directory" ]; then
  die "Ошибка: '$directory' не является каталогом."
fi

# Поиск и переименование файлов
find "$directory" -type f | while read -r file; do
  # Получаем имя файла без пути
  filename=$(basename -- "$file")

  # Проверка суффикса
  if [[ $filename == *"$old_suffix" ]]; then
    # Получаем имя файла без суффикса
    base_filename="${filename%$old_suffix}"

    # Формируем новое имя файла
    new_filename="${base_filename}$new_suffix"

    # Переименовываем файл
    mv "$file" "$(dirname -- "$file")/$new_filename"

    # Выводим информацию о переименовании
    echo "Переименован файл: $filename -> $new_filename"
  fi
done

echo "Готово!"
