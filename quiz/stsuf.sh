#!/bin/bash

# Function to recursively traverse the directory and gather statistics
traverse_directory() {
    local dir="$1"
    local -A suffix_count

    # Loop through all files in the directory
    while IFS= read -r -d '' file; do
        suffix=$(get_suffix "$file")
        ((suffix_count[$suffix]++))
    done < <(find "$dir" -type f -print0)

    # Output the statistics
    for key in "${!suffix_count[@]}"; do
        echo "$key: ${suffix_count[$key]}"
    done | sort -rn -k2
}

# Check the number of arguments
if [ "$#" -ne 1 ]; then
    echo "Ошибка: Пожалуйста, укажите только один аргумент - путь к каталогу."
    exit 1
fi

directory="$1"

# Check if the directory exists
if [ ! -d "$directory" ]; then
    echo "Ошибка: Указанный путь не является каталогом."
    exit 1
fi

# Function to get the suffix from a file name
get_suffix() {
    local filename=$(basename -- "$1")
    local suffix="${filename##*.}"  # Get the suffix
    if [ "$suffix" = "$filename" ]; then
        suffix="no suffix"  # Assign "no suffix" if no suffix exists
    fi
    echo "$suffix"
}

# Start the recursive traversal
traverse_directory "$directory"
