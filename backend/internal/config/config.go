package config

import (
	"log"
	"os"

	"github.com/joho/godotenv"
)

// Config centralizes runtime configuration.
type Config struct {
	HTTPPort string
	JWTSecret string
	DBURL    string
}

// Load reads environment variables and returns Config.
func Load() (*Config, error) {
	_ = godotenv.Load()

	cfg := &Config{
		HTTPPort: getenv("HTTP_PORT", "8080"),
		JWTSecret: getenv("JWT_SECRET", "b355cd45-095f-4e95-88c4-60a667437af6"),
		DBURL:    getenv("DATABASE_URL", "postgres://postgres:B3nd1c1on150R$@db.sklyfckdiyvvuosguegg.supabase.co:5432/postgres?sslmode=require"),
	}

	log.Printf("config loaded: http=%s db=%s", cfg.HTTPPort, cfg.DBURL)
	return cfg, nil
}

func getenv(key, def string) string {
	if v := os.Getenv(key); v != "" {
		return v
	}
	return def
}
