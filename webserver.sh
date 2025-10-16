#!/bin/bash
# Простейший веб-сервер на Bash + netcat

# Удаляем старый FIFO (если есть) и создаём новый
rm -f response
mkfifo response

# Функция для обработки HTTP-запроса
function handleRequest() {
  local REQUEST=""
  local HEADLINE_REGEX='(.*?)\s(.*?)\sHTTP.*?'

  # Читаем запрос построчно, пока не встретим пустую строку
  while read line; do
    trline=$(echo "$line" | tr -d '\r\n')
    [ -z "$trline" ] && break

    # Если строка совпадает с первой (headline), извлекаем метод и путь
    if [[ "$trline" =~ $HEADLINE_REGEX ]]; then
      REQUEST=$(echo "$trline" | sed -E "s/$HEADLINE_REGEX/\1 \2/")
    fi
  done

  # Формируем ответ в зависимости от запроса
  case "$REQUEST" in
    "GET /")
      RESPONSE="HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<h1>PONG</h1>"
      ;;
    *)
      RESPONSE="HTTP/1.1 404 NotFound\r\nContent-Type: text/plain\r\n\r\nNot Found"
      ;;
  esac

  # Отправляем ответ в FIFO
  echo -e "$RESPONSE" > response
}

echo "Listening on port 3000..."

# Запускаем сервер: читаем из FIFO, слушаем порт 3000, обрабатываем запросы
cat response | nc -lN 3000 | handleRequest
