package http

import (
	"net/http"

	"github.com/gin-gonic/gin"

	"github.com/crefigex/live/backend/internal/domain"
	"github.com/crefigex/live/backend/internal/service"
)

type VideoHandler struct {
	videos *service.VideoService
}

func NewVideoHandler(videos *service.VideoService) *VideoHandler {
	return &VideoHandler{videos: videos}
}

func (h *VideoHandler) Create(c *gin.Context) {
	var req domain.Video
	if err := c.ShouldBindJSON(&req); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": err.Error()})
		return
	}
	req.VendorID = c.GetString("userID")
	if err := h.videos.Create(c.Request.Context(), &req); err != nil {
		c.JSON(http.StatusInternalServerError, gin.H{"error": err.Error()})
		return
	}
	c.JSON(http.StatusCreated, gin.H{"video": req})
}

func (h *VideoHandler) ListMine(c *gin.Context) {
	data, _ := h.videos.ListByVendor(c.Request.Context(), c.GetString("userID"))
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *VideoHandler) ListPublic(c *gin.Context) {
	data, _ := h.videos.ListByVendor(c.Request.Context(), "")
	c.JSON(http.StatusOK, gin.H{"data": data})
}

func (h *VideoHandler) Get(c *gin.Context) {
	v, _ := h.videos.Get(c.Request.Context(), c.Param("id"))
	c.JSON(http.StatusOK, gin.H{"video": v})
}
