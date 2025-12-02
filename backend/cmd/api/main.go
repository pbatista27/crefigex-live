package main

import (
	"log"

	"github.com/crefigex/live/backend/internal/config"
	"github.com/crefigex/live/backend/internal/http"
)

func main() {
	cfg, err := config.Load()
	if err != nil {
		log.Fatalf("config error: %v", err)
	}

	router := http.NewRouter(cfg)

	if err := router.Run(":" + cfg.HTTPPort); err != nil {
		log.Fatalf("server error: %v", err)
	}
}
