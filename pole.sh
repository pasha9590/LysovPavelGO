#!/bin/bash
echo "Введите слово, которое будут отгадывать:"
read -s word  # скрытый ввод
len=${#word}
zagadano=$(printf '_%.0s' $(seq 1 $len))  # "_" сколько букв
echo "Слово: $zagadano"
while [[ "$zagadano" != "$word" ]]; do
    echo -n "Введите букву: "
    read letter

    new_zagadano=""
    found=0

    for (( i=0; i<$len; i++ )); do
        if [[ "${word:$i:1}" == "$letter" ]]; then
            new_zagadano+="$letter"
            found=1
        else
            new_zagadano+="${zagadano:$i:1}"
        fi
    done

    zagadano=$new_zagadano

    if [[ $found -eq 1 ]]; then
        echo "угадали"
    else
        echo "мимо"
    fi

    echo "Слово: $zagadano"
done

echo "слово: $word"