package main

import (
	"fmt"
	"log"
	"net/http"
	"time"
)

func main() {
	// Запускаем горутину для периодического вывода
	go func() {
		ticker := time.NewTicker(10 * time.Second)
		defer ticker.Stop()
		
		for {
			select {
			case <-ticker.C:
				fmt.Printf("🕒 [%s] Hello World!\n", time.Now().Format("15:04:05"))
			}
		}
	}()

	// HTTP обработчики
	http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		fmt.Fprintf(w, `
<!DOCTYPE html>
<html>
<head>
    <title>Go Hello World Server</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 40px; }
        .container { max-width: 600px; margin: 0 auto; }
    </style>
</head>
<body>
    <div class="container">
        <h1>🚀 Go Hello World Server</h1>
        <p>Сервер работает в Docker контейнере</p>
        <p>Каждые 10 секунд в консоли выводится "Hello World"</p>
        <p><a href="/status">Статус</a></p>
    </div>
</body>
</html>
		`)
	})

	http.HandleFunc("/status", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintf(w, `{
			"status": "running",
			"message": "Go Hello World Server", 
			"timestamp": "%s"
		}`, time.Now().Format(time.RFC3339))
	})

	fmt.Println("🚀 Server starting on :8080")
	fmt.Println("📝 Hello World будет выводиться каждые 10 секунд в консоль...")
	log.Fatal(http.ListenAndServe(":8080", nil))
}