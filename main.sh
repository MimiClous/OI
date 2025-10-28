#!/bin/bash

check_disk_usage() {
    directory="$1"
    threshold="$2"


    if [ ! -d "$directory" ]; then
        echo "Ошибка: Директория '$directory' не существует."
        return 1
    fi
    if [ -z "$threshold" ]; then
        echo "Ошибка: Порог использования диска не указан. Порог установлен на 80."
        if [ "$threshold" -gt 100 ] || [ "$threshold" -lt 0 ]; then
            echo "Ошибка: Порог использования диска находится вне диапазона от 0 до 100. Порог установлен на 80."
            return 1
        fi
        $threshold = 80
    fi

    disk_usage=$(echo $(df -h "$directory" | awk 'NR==2 {print $5}' | sed 's/%//'))
    if ! [[ "$disk_usage" =~ ^[0-9]+$ ]]; then
        echo "Ошибка: Некорректное значение использования диска."
        return 1
    fi
    

    if [ "$disk_usage" -gt "$threshold" ]; then
        echo "Предупреждение: '$directory' занимает $disk_usage% и превышает порог $threshold%"
        return 0
    else
        echo "'$directory' занимает $disk_usage% и не превышает порог $threshold%"
        return 1
    fi


} 




# Вызов функции
check_disk_usage "$1" "$2"
