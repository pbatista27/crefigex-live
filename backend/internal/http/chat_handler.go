package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/service"
)

type ChatHandler struct {
	videos *service.VideoService
}

func NewChatHandler(videos *service.VideoService) *ChatHandler {
	return &ChatHandler{videos: videos}
}

func (h *ChatHandler) List(c *gin.Context) {
	since := c.Query("since")
	msgs, _ := h.videos.ListMessages(c.Request.Context(), c.Param("id"), since)
	c.JSON(http.StatusOK, gin.H{"data": msgs})
}

func (h *ChatHandler) Create(c *gin.Context) {
	var req struct {
		Message string `json:"message"`
	}
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	msg := &domain.VideoChatMessage{
		VideoID: c.Param("id"),
		SenderID: c.GetString("userID"),
		Message: req.Message,
	}
	if err := h.videos.CreateMessage(c.Request.Context(), msg); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"message": msg})
}
