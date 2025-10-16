#!/bin/bash
# Простейший веб-сервер на Bash + netcat

# Удаляем старый FIFO (если есть) и создаём новый
#!/bin/bash
# Simple Bash Web Server

# Директория для временных данных
WORKDIR="/tmp/webserver"
RESPONSE_FIFO="$WORKDIR/response"

# Подготовка окружения
mkdir -p "$WORKDIR"
rm -f "$RESPONSE_FIFO"
mkfifo "$RESPONSE_FIFO"

handleRequest() {
  while read line; do
    echo "$line"
    trline=$(echo "$line" | tr -d '[\r\n]')
    [ -z "$trline" ] && break
  done

  echo -e 'HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n<h1>PONG</h1>' > "$RESPONSE_FIFO"
}

echo "Listening on port 3000..."

cd "$WORKDIR" || exit 1
cat "$RESPONSE_FIFO" | nc -lN 3000 | handleRequest
