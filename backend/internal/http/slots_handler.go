package http

import (
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
)

// SlotsHandler returns basic available slots placeholder.
type SlotsHandler struct{}

func NewSlotsHandler() *SlotsHandler { return &SlotsHandler{} }

func (h *SlotsHandler) List(c *gin.Context) {
	// Placeholder slots each 2 hours for the next day.
	var slots []string
	start := time.Now().Add(24 * time.Hour).Truncate(time.Hour)
	for i := 0; i < 6; i++ {
		slots = append(slots, start.Add(time.Duration(i*2)*time.Hour).Format(time.RFC3339))
	}
	c.JSON(http.StatusOK, gin.H{"slots": slots})
}
